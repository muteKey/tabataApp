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
  /// Rest
  internal static let breakBetweenLaps = L10n.tr("Localizable", "break_between_laps", fallback: "Rest")
  /// Break Duration
  internal static let breakDuration = L10n.tr("Localizable", "break_duration", fallback: "Break Duration")
  /// Break duration should be greater than zero
  internal static let breakDurationError = L10n.tr("Localizable", "break_duration_error", fallback: "Break duration should be greater than zero")
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
  /// Minutes
  internal static let minutes = L10n.tr("Localizable", "minutes", fallback: "Minutes")
  /// My Trainings
  internal static let myTrainings = L10n.tr("Localizable", "my_trainings", fallback: "My Trainings")
  /// Number of laps
  internal static let numberOfLaps = L10n.tr("Localizable", "number_of_laps", fallback: "Number of laps")
  /// Phase time
  internal static let phaseDuration = L10n.tr("Localizable", "phase_duration", fallback: "Phase time")
  /// Phase Title
  internal static let phaseTitle = L10n.tr("Localizable", "phase_title", fallback: "Phase Title")
  /// Phase title should not be empty
  internal static let phaseTitleError = L10n.tr("Localizable", "phase_title_error", fallback: "Phase title should not be empty")
  /// Save
  internal static let save = L10n.tr("Localizable", "save", fallback: "Save")
  /// Seconds
  internal static let seconds = L10n.tr("Localizable", "seconds", fallback: "Seconds")
  /// Sets
  internal static let sets = L10n.tr("Localizable", "sets", fallback: "Sets")
  /// Skip
  internal static let skip = L10n.tr("Localizable", "skip", fallback: "Skip")
  /// Stop
  internal static let stop = L10n.tr("Localizable", "stop", fallback: "Stop")
  /// Time Left
  internal static let timeLeft = L10n.tr("Localizable", "time_left", fallback: "Time Left")
  /// Total time
  internal static let totalDuration = L10n.tr("Localizable", "total_duration", fallback: "Total time")
  /// Total training progress
  internal static let totalTraining = L10n.tr("Localizable", "total_training", fallback: "Total training progress")
  /// Break between laps duration should be greater than zero
  internal static let trainingBreakBetweenLapsError = L10n.tr("Localizable", "training_break_between_laps_error", fallback: "Break between laps duration should be greater than zero")
  /// Training Finished
  internal static let trainingFinished = L10n.tr("Localizable", "training_finished", fallback: "Training Finished")
  /// Training Name
  internal static let trainingName = L10n.tr("Localizable", "training_name", fallback: "Training Name")
  /// Training title should not be empty
  internal static let trainingTitleError = L10n.tr("Localizable", "training_title_error", fallback: "Training title should not be empty")
  /// Set Duration
  internal static let workDuration = L10n.tr("Localizable", "work_duration", fallback: "Set Duration")
  /// Set duration should be greater than zero
  internal static let workDurationError = L10n.tr("Localizable", "work_duration_error", fallback: "Set duration should be greater than zero")
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
