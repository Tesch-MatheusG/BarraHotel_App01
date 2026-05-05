import 'package:flutter/material.dart';
import '../../data/usuario_mock_store.dart';
import '../../models/usuario_model.dart';
import '../cores.dart';

class AdmFuncionariosPage extends StatefulWidget {
  const AdmFuncionariosPage({super.key});

  @override
  State<AdmFuncionariosPage> createState() => _AdmFuncionariosPageState();
}

class _AdmFuncionariosPageState extends State<AdmFuncionariosPage> {
  final TextEditingController _buscaController = TextEditingController();
  String _busca = '';

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<UsuarioModel> get _usuariosFiltrados {
    final todos = UsuarioMockStore.todos
        .where((u) => u.perfil != PerfilUsuario.master)
        .toList();
    if (_busca.isEmpty) return todos;
    return todos
        .where((u) =>
            u.nome.toLowerCase().contains(_busca.toLowerCase()) ||
            u.email.toLowerCase().contains(_busca.toLowerCase()))
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
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                const Expanded(
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
            child: _usuariosFiltrados.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.manage_accounts_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum usuário encontrado.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _usuariosFiltrados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _CardUsuario(
                        usuario: _usuariosFiltrados[index],
                        onAtualizar: () => setState(() {}),
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
  final UsuarioModel usuario;
  final VoidCallback onAtualizar;

  const _CardUsuario({
    required this.usuario,
    required this.onAtualizar,
  });

  bool get _isAdm => usuario.perfil == PerfilUsuario.adm;

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

          // AVATAR
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

          // DADOS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario.nome,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  usuario.email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
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

          // BOTÃO DE AÇÃO
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
                  ? 'Deseja promover "${usuario.nome}" a ADM?\n\nEle terá acesso ao painel administrativo.'
                  : 'Deseja rebaixar "${usuario.nome}" para Cliente?\n\nEle perderá acesso ao painel administrativo.',
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
              UsuarioMockStore.promover(
                usuario.email,
                promovendo ? PerfilUsuario.adm : PerfilUsuario.cliente,
              );
              Navigator.pop(context);
              onAtualizar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    promovendo
                        ? '${usuario.nome} agora é ADM!'
                        : '${usuario.nome} foi rebaixado para Cliente.',
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