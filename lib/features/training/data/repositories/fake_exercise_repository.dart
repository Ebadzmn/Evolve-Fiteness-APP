import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';

class FakeExerciseRepository {
  Future<List<ExerciseEntity>> loadAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const [
      ExerciseEntity(
        id: 'bench_press',
        title: 'Bench Press',
        category: 'Chest',
        equipment: 'Barbell',
        tags: ['Chest', 'Triceps', 'Shoulders'],
        description:
            'Focuses on chest strength and pressing power. Helps build triceps and shoulders.',
        imageUrl:
            'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1470&q=80',
      ),
      ExerciseEntity(
        id: 'shoulder_press',
        title: 'Shoulder Press',
        category: 'Back',
        equipment: 'Barbell',
        tags: ['Triceps', 'Shoulders'],
        description:
            'Strengthens shoulders and improves overhead pressing stability.',
        imageUrl:
            'https://images.unsplash.com/photo-1526506118085-60c1502b7c34?auto=format&fit=crop&w=1470&q=80',
      ),
      ExerciseEntity(
        id: 'deadlift',
        title: 'Deadlift',
        category: 'Back',
        equipment: 'Barbell',
        tags: ['Back', 'Hamstrings', 'Glutes'],
        description: 'Full-body lift focusing on posterior chain strength.',
        imageUrl:
            'https://images.unsplash.com/photo-1534438327276-14e5300cf099?auto=format&fit=crop&w=1470&q=80',
      ),
      ExerciseEntity(
        id: 'squat',
        title: 'Squat',
        category: 'Legs',
        equipment: 'Barbell',
        tags: ['Quads', 'Glutes'],
        description: 'Builds lower body strength and core stability.',
        imageUrl:
            'https://images.unsplash.com/photo-1517960121705-4d27f1f3f4e1?auto=format&fit=crop&w=1470&q=80',
      ),
    ];
  }
}
