import '../../../data/repositories/fake_checkin_repository.dart';
import '../../entities/checkin_entities/old_check_in_entity.dart';

class GetCheckInUserUseCase {
  final FakeCheckInRepository repository;

  GetCheckInUserUseCase(this.repository);

  Future<OldCheckInEntity?> call() async {
    return await repository.getCheckInUser();
  }
}
