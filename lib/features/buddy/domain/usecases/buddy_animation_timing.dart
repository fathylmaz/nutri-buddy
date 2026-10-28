/// A small hold window for the NutriBuddy Rive One-Shot reaction clips.
///
/// Current Rive design: Happy = 100 frames / 60 fps (~1667 ms),
/// Energetic = 64 frames / 60 fps (~1067 ms). A short safety margin is
/// included so the clip is not cut off before returning to the Idle loop.
/// Update these durations if you change clip lengths in Rive Editor.
Duration? buddyReactionDuration(String mood) {
  switch (mood) {
    case 'happy':
      return const Duration(milliseconds: 1800);
    case 'energetic':
      return const Duration(milliseconds: 1200);
    default:
      return null;
  }
}
