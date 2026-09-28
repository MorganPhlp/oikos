enum ExclusionKind { action, category, tag }

class ExcludedPreference {
  final ExclusionKind kind;
  final String value;
  final String label;
  const ExcludedPreference(this.kind, this.value, this.label);
}
