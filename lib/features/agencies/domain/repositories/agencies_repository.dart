import '../entities/agency.dart';

abstract class AgenciesRepository {
  List<Agency> current();
  String? selectedAgencyId();
  Stream<List<Agency>> watch();
  Future<void> load();
  Future<void> addAgency(Agency agency);
  Future<void> selectAgency(String agencyId);
}
