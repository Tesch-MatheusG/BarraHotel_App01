import 'package:flutter/material.dart';
import '../../data/usuario_mock_store.dart';
import '../../models/usuario_model.dart';
import '../cores.dart';

// Página de gerenciamento de funcionários — acessível apenas pelo perfil master
class AdmFuncionariosPage extends StatefulWidget {
  const AdmFuncionariosPage({super.key});

  @override
  State<AdmFuncionariosPage> createState() => _AdmFuncionariosPageState();
}

class _AdmFuncionariosPageState extends State<AdmFuncionariosPage> {
  final TextEditingController _buscaController = TextEditingController(); // controlador do campo de busca
  String _busca = ''; // texto digitado na busca

  @override
  void dispose() {
    _buscaController.dispose(); // libera o controller ao sair da página
    super.dispose();
  }

  // Retorna usuários filtrados pela busca, excluindo o perfil master da listagem
  List<UsuarioModel> get _usuariosFiltrados {
    final todos = UsuarioMockStore.todos
        .where((u) => u.perfil != PerfilUsuario.master) // oculta o master da lista
        .toList();
    if (_busca.isEmpty) return todos; // sem filtro, retorna todos
    return todos
        .where((u) =>
            u.nome.toLowerCase().contains(_busca.toLowerCase()) ||
            u.email.toLowerCase().contains(_busca.toLowerCase())) // filtra por nome ou e-mail
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
              onChanged: (v) => setState(() => _busca = v), // atualiza o filtro a cada caractere digitado
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

          // LEGENDA informando a funcionalidade da tela
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

          // LISTA de usuários filtrados
          Expanded(
            child: _usuariosFiltrados.isEmpty
                // estado vazio — nenhum usuário encontrado na busca
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
                // lista com card de cada usuário
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _usuariosFiltrados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _CardUsuario(
                        usuario: _usuariosFiltrados[index],
                        onAtualizar: () => setState(() {}), // reconstrói a lista após promoção/rebaixamento
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Card individual de cada usuário na listagem
class _CardUsuario extends StatelessWidget {
  final UsuarioModel usuario;
  final VoidCallback onAtualizar; // callback para atualizar a lista após mudança de perfil

  const _CardUsuario({
    required this.usuario,
    required this.onAtualizar,
  });

  // Verifica se o usuário atual é administrador
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
              ? AppColors.azulEscuro.withOpacity(0.3) // borda azul para ADMs
              : AppColors.cinzaBorda, // borda cinza para clientes
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

          // AVATAR com ícone diferente por perfil
          CircleAvatar(
            radius: 24,
            backgroundColor: _isAdm
                ? AppColors.azulEscuro.withOpacity(0.1)
                : AppColors.azulClaro,
            child: Icon(
              _isAdm ? Icons.manage_accounts : Icons.person, // ícone de adm ou cliente
              color: AppColors.azulEscuro,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          // DADOS do usuário (nome, e-mail e badge de perfil)
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
                // Badge colorida indicando o perfil do usuário
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

          // BOTÃO que alterna entre promover e rebaixar conforme o perfil atual
          TextButton(
            onPressed: () => _confirmarMudancaPerfil(context),
            style: TextButton.styleFrom(
              foregroundColor:
                  _isAdm ? AppColors.vermelho : AppColors.azulEscuro, // vermelho para rebaixar, azul para promover
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

  // Exibe diálogo de confirmação antes de alterar o perfil do usuário
  void _confirmarMudancaPerfil(BuildContext context) {
    final promovendo = !_isAdm; // true = promovendo para ADM, false = rebaixando para cliente

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(promovendo ? 'Promover a ADM' : 'Rebaixar para Cliente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mensagem descritiva da ação
            Text(
              promovendo
                  ? 'Deseja promover "${usuario.nome}" a ADM?\n\nEle terá acesso ao painel administrativo.'
                  : 'Deseja rebaixar "${usuario.nome}" para Cliente?\n\nEle perderá acesso ao painel administrativo.',
            ),
            const SizedBox(height: 12),
            // Bloco informativo com ícone — verde para promoção, vermelho para rebaixamento
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
          // Botão de cancelar — fecha o diálogo sem alterar nada
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          // Botão de confirmação — aplica a mudança de perfil e exibe snackbar
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  promovendo ? AppColors.azulEscuro : AppColors.vermelho,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              UsuarioMockStore.promover(
                usuario.email,
                promovendo ? PerfilUsuario.adm : PerfilUsuario.cliente, // define o novo perfil
              );
              Navigator.pop(context); // fecha o diálogo
              onAtualizar(); // atualiza a lista na tela
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