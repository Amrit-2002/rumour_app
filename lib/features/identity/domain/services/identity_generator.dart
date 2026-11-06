import 'dart:math';

class GeneratedPersona {
  final String adjective;
  final String animal;

  const GeneratedPersona({
    required this.adjective,
    required this.animal,
  });

  String get fullName => '$adjective $animal';
}

class IdentityGenerator {
  IdentityGenerator._();

  static final Random _random = Random.secure();

  static const List<String> adjectives = [
    'Silent', 'Neon', 'Electric', 'Velvet', 'Shadow', 'Crimson', 'Golden', 'Cosmic',
    'Mystic', 'Rapid', 'Silver', 'Astral', 'Frozen', 'Solar', 'Fierce', 'Gentle',
    'Lunar', 'Vibrant', 'Phantom', 'Storm', 'Brave', 'Wild', 'Chill', 'Secret',
    'Radiant', 'Turbo', 'Iron', 'Echo', 'Stealth', 'Hyper', 'Swift', 'Amber',
    'Cobalt', 'Blazing', 'Frost', 'Zen', 'Static', 'Quantum', 'Glitch', 'Nova',
    'Rustic', 'Noble', 'Prism', 'Midnight', 'Apex', 'Vortex', 'Pulse', 'Cipher',
    'Onyx', 'Mirage'
  ];

  static const List<String> animals = [
    'Falcon', 'Panther', 'Otter', 'Badger', 'Fox', 'Wolf', 'Hawk', 'Cheetah',
    'Raven', 'Tiger', 'Lynx', 'Jaguar', 'Eagle', 'Owl', 'Bear', 'Cobra',
    'Viper', 'Panda', 'Koala', 'Bison', 'Shark', 'Dolphin', 'Stag', 'Leopard',
    'Moose', 'Rhino', 'Mongoose', 'Gazelle', 'Chameleon', 'Gecko', 'Penguin',
    'Heron', 'Crane', 'Dragonfly', 'Orca', 'Foxhound', 'Wombat', 'Hedgehog',
    'Beaver', 'Salamander', 'Ocelot', 'Kangaroo', 'Meerkat', 'Lemur', 'Jackal',
    'Condor', 'Ibex', 'Grizzly', 'Stallion', 'Mustang'
  ];

  /// Generates a random Adjective + Animal pair
  static GeneratedPersona generate() {
    final adjIndex = _random.nextInt(adjectives.length);
    final animalIndex = _random.nextInt(animals.length);
    return GeneratedPersona(
      adjective: adjectives[adjIndex],
      animal: animals[animalIndex],
    );
  }
}

