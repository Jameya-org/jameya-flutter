import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A reusable "Smart Animate" slide transition inspired by Figma's Smart Animate.
/// Slides content in from the right with ease-out at 300ms,
/// matching: animation-timing-function: ease-out; animation-duration: 300ms;
///
/// Usage with AnimatedSwitcher:
/// ```dart
/// AnimatedSwitcher(
///   duration: SmartAnimateTransition.duration,
///   transitionBuilder: SmartAnimateTransition.transitionBuilder,
///   child: YourWidget(key: ValueKey(uniqueKey)),
/// )
/// ```
///
/// Usage with GoRouter:
/// ```dart
/// pageBuilder: (context, state) =>
///     SmartAnimateTransition.buildPage(state: state, child: MyView()),
/// ```
class SmartAnimateTransition {
  SmartAnimateTransition._();

  /// 300ms — matches Figma animation-duration
  static const Duration duration = Duration(milliseconds: 300);

  /// Alias for [duration] — used for PageView.nextPage()
  static const Duration pageDuration = duration;

  /// ease-out — matches Figma animation-timing-function
  static const Curve curve = Curves.easeOut;

  /// Alias for [curve] — used for PageView.nextPage()
  static const Curve pageCurve = curve;

  /// Transition builder for [AnimatedSwitcher].
  /// Slides in from the right (subtle 8% offset) + fades in.
  static Widget transitionBuilder(Widget child, Animation<double> animation) {
    final curved = CurvedAnimation(parent: animation, curve: curve);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.08, 0),
        end: Offset.zero,
      ).animate(curved),
      child: FadeTransition(
        opacity: curved,
        child: child,
      ),
    );
  }

  /// Builds a [CustomTransitionPage] for GoRouter using this animation.
  static CustomTransitionPage<T> buildPage<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          transitionBuilder(child, animation),
    );
  }
}
