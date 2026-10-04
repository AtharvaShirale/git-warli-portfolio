/// A simple immutable data class representing a portfolio project.
///
/// We use a plain Dart class with `const` constructor so instances can be
/// compile-time constants, which is efficient and fits nicely in a `const` list.
class Project {
  final String title;
  final String description;
  final String stack;
  final String link;

  const Project(this.title, this.description, this.stack, this.link);
}
