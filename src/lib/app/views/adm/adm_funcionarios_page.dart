import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../cores.dart';

class AdmFuncionariosPage extends StatefulWidget {
  const AdmFuncionariosPage({super.key});

  @override
  State<AdmFuncionariosPage> createState() => _AdmFuncionariosPageState();
}

class _AdmFuncionariosPageState extends State<AdmFuncionariosPage> {
  final TextEditingController _buscaController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String _busca = '';
  List<Map<String, dynamic>> _usuarios = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarUsuarios() async {
    setState(() => _carregando = true);
    try {
      final snapshot = await _firestore.collection('usuarios').get();
      setState(() {
        _usuarios = snapshot.docs
            .where((doc) => doc.data()['perfil'] != 'master')
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar usuários.')),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _alterarPerfil(String docId, String novoPerfil) async {
    await _firestore
        .collection('usuarios')
        .doc(docId)
        .update({'perfil': novoPerfil});
    _carregarUsuarios();
  }

  List<Map<String, dynamic>> get _usuariosFiltrados {
    if (_busca.isEmpty) return _usuarios;
    return _usuarios.where((u) =>
        u['nome'].toString().toLowerCase().contains(_busca.toLowerCase()) ||
        u['email'].toString().toLowerCase().contains(_busca.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Funcionários',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarUsuarios,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Column(
        children: [

          // BARRA DE BUSCA
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _buscaController,
              onChanged: (v) => setState(() => _busca = v),
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou e-mail...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.azulEscuro,
                ),
                filled: true,
                fillColor: AppColors.fundoPagina,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // LEGENDA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: const [
                Icon(Icons.info_outline, size: 14, color: Colors.grey),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Promova clientes a ADM ou rebaixe ADMs a clientes.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          // LISTA
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _usuariosFiltrados.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.manage_accounts_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Nenhum usuário encontrado.',
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _usuariosFiltrados.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final usuario = _usuariosFiltrados[index];
                          return _CardUsuario(
                            usuario: usuario,
                            onAlterarPerfil: (novoPerfil) =>
                                _alterarPerfil(usuario['id'], novoPerfil),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _CardUsuario extends StatelessWidget {
  final Map<String, dynamic> usuario;
  final Function(String novoPerfil) onAlterarPerfil;

  const _CardUsuario({
    required this.usuario,
    required this.onAlterarPerfil,
  });

  bool get _isAdm => usuario['perfil'] == 'adm';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isAdm
              ? AppColors.azulEscuro.withOpacity(0.3)
              : AppColors.cinzaBorda,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: _isAdm
                ? AppColors.azulEscuro.withOpacity(0.1)
                : AppColors.azulClaro,
            child: Icon(
              _isAdm ? Icons.manage_accounts : Icons.person,
              color: AppColors.azulEscuro,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario['nome'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  usuario['email'] ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _isAdm
                        ? AppColors.azulEscuro.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isAdm ? 'ADM' : 'Cliente',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _isAdm ? AppColors.azulEscuro : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _confirmarMudancaPerfil(context),
            style: TextButton.styleFrom(
              foregroundColor:
                  _isAdm ? AppColors.vermelho : AppColors.azulEscuro,
            ),
            child: Text(
              _isAdm ? 'Rebaixar' : 'Promover',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarMudancaPerfil(BuildContext context) {
    final promovendo = !_isAdm;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(promovendo ? 'Promover a ADM' : 'Rebaixar para Cliente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              promovendo
                  ? 'Deseja promover "${usuario['nome']}" a ADM?\n\nEle terá acesso ao painel administrativo.'
                  : 'Deseja rebaixar "${usuario['nome']}" para Cliente?\n\nEle perderá acesso ao painel administrativo.',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: promovendo
                    ? AppColors.azulClaro
                    : AppColors.vermelho.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    promovendo
                        ? Icons.check_circle_outline
                        : Icons.warning_outlined,
                    color: promovendo ? AppColors.azulEscuro : AppColors.vermelho,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      promovendo
                          ? 'O usuário poderá fazer check-in, check-out e registrar pagamentos.'
                          : 'Esta ação pode ser revertida a qualquer momento.',
                      style: TextStyle(
                        fontSize: 12,
                        color: promovendo
                            ? AppColors.azulEscuro
                            : AppColors.vermelho,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  promovendo ? AppColors.azulEscuro : AppColors.vermelho,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              onAlterarPerfil(promovendo ? 'adm' : 'cliente');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    promovendo
                        ? '${usuario['nome']} agora é ADM!'
                        : '${usuario['nome']} foi rebaixado para Cliente.',
                  ),
                  backgroundColor:
                      promovendo ? Colors.green : AppColors.vermelho,
                ),
              );
            },
            child: Text(promovendo ? 'Promover' : 'Rebaixar'),
          ),
        ],
      ),
    );
  }
}