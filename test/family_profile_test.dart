import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';

void main() {
  test('FamilyProfile survives a JSON round trip', () {
    const FamilyProfile originalProfile = FamilyProfile(
      nickname: 'Fatima',
      role: FamilyRole.grandparent,
    );

    final FamilyProfile? restoredProfile = FamilyProfile.fromJsonString(
      originalProfile.toJsonString(),
    );

    expect(restoredProfile, originalProfile);
  });

  test('FamilyProfile rejects damaged JSON', () {
    final FamilyProfile? profile = FamilyProfile.fromJsonString(
      'not valid json',
    );

    expect(profile, isNull);
  });

  test('FamilyProfile rejects unknown roles', () {
    final FamilyProfile? profile = FamilyProfile.fromJsonString(
      '{"nickname":"Fatima","role":"unknown"}',
    );

    expect(profile, isNull);
  });
}
