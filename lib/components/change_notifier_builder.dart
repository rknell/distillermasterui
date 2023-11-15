import 'package:flutter/widgets.dart';

class ChangeNotifierBuilder extends StatefulWidget {
  final ChangeNotifier notifier;
  final Widget Function(BuildContext context) builder;

  const ChangeNotifierBuilder({
    Key? key,
    required this.notifier,
    required this.builder,
  }) : super(key: key);

  @override
  _ChangeNotifierBuilderState createState() => _ChangeNotifierBuilderState();
}

class _ChangeNotifierBuilderState extends State<ChangeNotifierBuilder> {
  late ChangeNotifier oldObject;

  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_listener);
    oldObject = widget.notifier;
  }

  @override
  void didUpdateWidget(covariant ChangeNotifierBuilder oldWidget) {
    oldWidget.notifier.removeListener(_listener);
    widget.notifier.addListener(_listener);
    super.didUpdateWidget(oldWidget);
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.notifier.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}

class MultiChangeNotifierBuilder extends StatefulWidget {
  final List<ChangeNotifier> notifiers;
  final Widget Function(BuildContext context) builder;

  const MultiChangeNotifierBuilder(
      {Key? key, required this.notifiers, required this.builder})
      : super(key: key);

  @override
  _MultiChangeNotifierBuilderState createState() =>
      _MultiChangeNotifierBuilderState();
}

class _MultiChangeNotifierBuilderState
    extends State<MultiChangeNotifierBuilder> {
  @override
  void initState() {
    super.initState();
    for (var notifier in widget.notifiers) {
      notifier.addListener(_listener);
    }
  }

  void _listener() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    for (var notifier in widget.notifiers) {
      notifier.removeListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
