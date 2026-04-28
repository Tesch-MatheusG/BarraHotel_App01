import '../models/quarto_model.dart';

final List <CategoriaQuarto> categorias = [
  CategoriaQuarto(
    label: 'Single',
    quartos: [
      Quarto(
        nome: 'Apartamento Simples',
        numeroPessoas: 1,
        tipoCama: 'Cama box de solteiro',
        comodidades: ['Tv Smart', 'Ventilador'],
        preco: 180,
      ),
      Quarto(
        nome: 'Apartamento Simples com Ar',
        numeroPessoas: 1,
        tipoCama: 'Cama box de solteiro',
        comodidades: ['Tv Smart', 'Ar-condicionado'],
        preco: 220,
      ),
      Quarto(
        nome: 'Apartamento Standard',
        numeroPessoas: 1,
        tipoCama: 'Cama box de casal',
        comodidades: ['Tv Smart', 'Mesa de trabalho', 'Ventilador'],
        preco: 260,
      ),
      Quarto(
        nome: 'Apartamento Executivo',
        numeroPessoas: 1,
        tipoCama: 'Cama box de casal',
        comodidades: ['Tv Smart', 'Ar-condicionado', 'Frigobar', 'Mesa de trabalho'],
        preco: 320,
      ),
      Quarto(
        nome: 'Apartamento Master',
        numeroPessoas: 1,
        tipoCama: 'Cama king size',
        comodidades: [
          'Tv Smart',
          'Ar-condicionado',
          'Frigobar',
          'Copa',
          'Mesa de trabalho',
        ],
        preco: 420,
      ),
    ],
  ),

  CategoriaQuarto(
    label: 'Casal',
    quartos: [
      Quarto(
        nome: 'Apartamento Casal Simples',
        numeroPessoas: 2,
        tipoCama: 'Cama box de casal',
        comodidades: ['Tv Smart', 'Ventilador'],
        preco: 280,
      ),
      Quarto(
        nome: 'Apartamento Executivo',
        numeroPessoas: 2,
        tipoCama: 'Cama box de casal',
        comodidades: ['Tv Smart', 'Ar-condicionado', 'Frigobar', 'Mesa de trabalho'],
        preco: 340,
      ),
      Quarto(
        nome: 'Apartamento Master',
        numeroPessoas: 2,
        tipoCama: 'Cama king size',
        comodidades: [
          'Tv Smart',
          'Ar-condicionado',
          'Frigobar',
          'Copa',
          'Mesa de trabalho',
        ],
        preco: 480,
      ),
    ],
  ),

  CategoriaQuarto(
    label: 'Triplo',
    quartos: [
      Quarto(
        nome: 'Apartamento Triplo Simples',
        numeroPessoas: 3,
        tipoCama: '1 cama casal + 1 solteiro',
        comodidades: ['Tv Smart', 'Ventilador'],
        preco: 380,
      ),
      Quarto(
        nome: 'Apartamento Triplo com Ar',
        numeroPessoas: 3,
        tipoCama: '1 cama casal + 1 solteiro',
        comodidades: ['Tv Smart', 'Ar-condicionado', 'Frigobar'],
        preco: 440,
      ),
      Quarto(
        nome: 'Suite Tripla',
        numeroPessoas: 3,
        tipoCama: '1 cama king + 1 solteiro',
        comodidades: [
          'Tv Smart',
          'Ar-condicionado',
          'Frigobar',
          'Vista para o mar',
        ],
        preco: 560,
      ),
    ],
  ),

  CategoriaQuarto(
    label: 'Quádruplo',
    quartos: [
      Quarto(
        nome: 'Apartamento Executivo',
        numeroPessoas: 4,
        tipoCama: '1 cama box de casal e 2 camas de solteiro',
        comodidades: ['Tv Smart', 'Ar-condicionado', 'Frigobar', 'Mesa de trabalho'],
        preco: 580,
      ),
    ],
  ),
];
