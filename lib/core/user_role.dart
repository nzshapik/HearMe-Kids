enum UserRole { parent, kid }

extension UserRoleX on UserRole {
  String get storageValue => this == UserRole.parent ? 'parent' : 'kid';
  String get title => this == UserRole.parent ? 'Parent' : 'Kid';

  static UserRole? fromStorage(String? value) {
    if (value == 'parent') return UserRole.parent;
    if (value == 'kid') return UserRole.kid;
    return null;
  }
}
