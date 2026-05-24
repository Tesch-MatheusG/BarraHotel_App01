import '../models/quarto_model.dart';

// Lista de categorias de quartos disponíveis no hotel
final List <CategoriaQuarto> categorias = [
  CategoriaQuarto(
    label: 'Single',
    quartos: [
      Quarto(
        nome: 'Apartamento Simples',
        numeroPessoas: 1,
        tipoCama: 'Cama box de solteiro',
        comodidades: ['Tv Smart', 'Ventilador'],
        fotos: [
          'assets/images/quartos/simples_ventilador/1.jpg',
          'assets/images/quartos/simples_ventilador/2.jpg',
          'assets/images/quartos/simples_ventilador/3.jpg',
        ],
        preco: 180,
      ),
      Quarto(
        nome: 'Apartamento Simples com Ar',
        numeroPessoas: 1,
        tipoCama: 'Cama box de solteiro',
        comodidades: ['Tv Smart', 'Ar-condicionado'],
        fotos: [
          'assets/images/quartos/simples_ar/1.jpg',
          'assets/images/quartos/simples_ar/2.jpg',
          'assets/images/quartos/simples_ar/3.jpg',
        ],
        preco: 220,
      ),
      Quarto(
        nome: 'Apartamento Standard',
        numeroPessoas: 1,
        tipoCama: 'Cama box de casal',
        comodidades: ['Tv Smart', 'Mesa de trabalho', 'Ventilador'],
        fotos: [
          'assets/images/quartos/standard_single/1.jpg',
          'assets/images/quartos/standard_single/2.jpg',
        ],
        preco: 260,
      ),
      Quarto(
        nome: 'Apartamento Executivo',
        numeroPessoas: 1,
        tipoCama: 'Cama box de casal',
        comodidades: ['Tv Smart', 'Ar-condicionado', 'Frigobar', 'Mesa de trabalho'],
        fotos: [
          'assets/images/quartos/executivo_single/1.jpg',
          'assets/images/quartos/executivo_single/2.jpg',
          'assets/images/quartos/executivo_single/3.jpg',
        ],
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
        fotos: [
          'assets/images/quartos/master_single/1.jpg',
          'assets/images/quartos/master_single/2.jpg',
          'assets/images/quartos/master_single/3.jpg',
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
        fotos: [
          'assets/images/quartos/standard_casal/1.jpg',
          'assets/images/quartos/standard_casal/2.jpg',
        ],
        preco: 280,
      ),
      Quarto(
        nome: 'Apartamento Executivo',
        numeroPessoas: 2,
        tipoCama: 'Cama box de casal',
        comodidades: ['Tv Smart', 'Ar-condicionado', 'Frigobar', 'Mesa de trabalho'],
        fotos: [
          'assets/images/quartos/executivo_casal/1.jpg',
          'assets/images/quartos/executivo_casal/2.jpg',
          'assets/images/quartos/executivo_casal/3.jpg',
        ],
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
        fotos: [
          'assets/images/quartos/master_casal/1.jpg',
          'assets/images/quartos/master_casal/2.jpg',
          'assets/images/quartos/master_casal/3.jpg',
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
        fotos: [
          'assets/images/quartos/standard_triplo/1.jpg',
          'assets/images/quartos/standard_triplo/2.jpg',
          'assets/images/quartos/standard_triplo/3.jpg',
        ],
        preco: 380,
      ),
      Quarto(
        nome: 'Apartamento Triplo com Ar',
        numeroPessoas: 3,
        tipoCama: '1 cama casal + 1 solteiro',
        comodidades: ['Tv Smart', 'Ar-condicionado', 'Frigobar'],
        fotos: [
          'assets/images/quartos/executivo_triplo/1.jpg',
          'assets/images/quartos/executivo_triplo/2.jpg',
          'assets/images/quartos/executivo_triplo/3.jpg',
        ],
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
        fotos: [
          'assets/images/quartos/master_triplo/1.jpg',
          'assets/images/quartos/master_triplo/2.jpg',
          'assets/images/quartos/master_triplo/3.jpg',
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
        fotos: [
          'assets/images/quartos/executivo_quadruplo/1.jpg',
          'assets/images/quartos/executivo_quadruplo/2.jpg',
          'assets/images/quartos/executivo_quadruplo/3.jpg',
        ],
        preco: 580,
      ),
    ],
  ),
];
