import '../../entities/checkin_entities/check_in_date_entity.dart';
import '../../../data/repositories/fake_checkin_repository.dart';

class GetCheckInDateUseCase {
  final FakeCheckInRepository repository;

  GetCheckInDateUseCase(this.repository);

  Future<CheckInDateEntity> call() async {
    return await repository.getCheckInDate();
  }
}
