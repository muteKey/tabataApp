// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Add Lap
  internal static let addLap = L10n.tr("Localizable", "add_lap", fallback: "Add Lap")
  /// Add New Training
  internal static let addNewTraining = L10n.tr("Localizable", "add_new_training", fallback: "Add New Training")
  /// Add Phase
  internal static let addPhase = L10n.tr("Localizable", "add_phase", fallback: "Add Phase")
  /// Add Training
  internal static let addTraining = L10n.tr("Localizable", "add_training", fallback: "Add Training")
  /// Break
  internal static let `break` = L10n.tr("Localizable", "break", fallback: "Break")
  /// Break between laps
  internal static let breakBetweenLaps = L10n.tr("Localizable", "break_between_laps", fallback: "Break between laps")
  /// Break Duration
  internal static let breakDuration = L10n.tr("Localizable", "break_duration", fallback: "Break Duration")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel", fallback: "Cancel")
  /// Edit
  internal static let edit = L10n.tr("Localizable", "edit", fallback: "Edit")
  /// Edit Training
  internal static let editTraining = L10n.tr("Localizable", "edit_training", fallback: "Edit Training")
  /// Lap
  internal static let lap = L10n.tr("Localizable", "lap", fallback: "Lap")
  /// Launch
  internal static let launch = L10n.tr("Localizable", "launch", fallback: "Launch")
  /// My Trainings
  internal static let myTrainings = L10n.tr("Localizable", "my_trainings", fallback: "My Trainings")
  /// Number of laps
  internal static let numberOfLaps = L10n.tr("Localizable", "number_of_laps", fallback: "Number of laps")
  /// Phase Duration
  internal static let phaseDuration = L10n.tr("Localizable", "phase_duration", fallback: "Phase Duration")
  /// Phase Title
  internal static let phaseTitle = L10n.tr("Localizable", "phase_title", fallback: "Phase Title")
  /// Save
  internal static let save = L10n.tr("Localizable", "save", fallback: "Save")
  /// Skip
  internal static let skip = L10n.tr("Localizable", "skip", fallback: "Skip")
  /// Stop
  internal static let stop = L10n.tr("Localizable", "stop", fallback: "Stop")
  /// Time Left
  internal static let timeLeft = L10n.tr("Localizable", "time_left", fallback: "Time Left")
  /// Total duration
  internal static let totalDuration = L10n.tr("Localizable", "total_duration", fallback: "Total duration")
  /// Total training progress
  internal static let totalTraining = L10n.tr("Localizable", "total_training", fallback: "Total training progress")
  /// Training Finished
  internal static let trainingFinished = L10n.tr("Localizable", "training_finished", fallback: "Training Finished")
  /// Training Name
  internal static let trainingName = L10n.tr("Localizable", "training_name", fallback: "Training Name")
  /// Work Duration
  internal static let workDuration = L10n.tr("Localizable", "work_duration", fallback: "Work Duration")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type