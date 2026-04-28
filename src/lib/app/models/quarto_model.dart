class Quarto {
  final String nome;
  final int numeroPessoas;
  final String tipoCama;
  final List<String> comodidades;
  final double preco;

  const Quarto({
    required this.nome,
    required this.numeroPessoas,
    required this.tipoCama,
    required this.comodidades,
    required this.preco,
  });
}

class CategoriaQuarto {
  final String label;
  final List<Quarto> quartos;

  const CategoriaQuarto({required this.label, required this.quartos});
}