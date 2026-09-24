# Prompt: Wire up real progress logic for a trip's `LinearProgressIndicator`

The trip details card has a `LinearProgressIndicator` that's currently hardcoded to a static value (e.g. `0.9`) — it's pure UI with no logic behind it. Replace it with a real progress calculation driven by the trip's actual state.

## Requirements

1. **Widget change**: Add a `progress` (double, 0.0–1.0, default `0.0`) parameter to the card widget. Pass it into the `LinearProgressIndicator` as `value: progress.clamp(0.0, 1.0)` so it's always safe even if upstream logic produces an out-of-range number.

2. **Progress calculation** (in the parent screen/state, not the dumb widget):
   - If the trip hasn't started yet (phase is e.g. `PENDING`/`SCHEDULED`), return `0.0`.
   - If the trip is `COMPLETED`, return `1.0`.
   - If the trip is `IN_PROGRESS`:
     - **Preferred**: use the driver's live GPS position vs. the destination coordinates. Compute `remainingMeters = distanceBetween(currentLat, currentLng, destLat, destLng)` and `totalMeters = totalTripDistanceKm * 1000`, then `progress = (1 - remainingMeters/totalMeters).clamp(0.0, 1.0)`.
     - **Fallback** (no GPS fix yet): use elapsed time vs. ETA duration — `progress = (elapsedSeconds / etaDurationSeconds).clamp(0.0, 1.0)`, where `elapsedSeconds = now - departureDateTime`.

3. **Live location tracking**:
   - Add a `StreamSubscription<Position>?` field and a `Position? _currentPosition` field to the screen's state.
   - Start streaming only once (`if (_positionStream != null) return;`), and only once the trip is confirmed in progress — not on every rebuild.
   - Check `Geolocator.isLocationServiceEnabled()` and permission status (`checkPermission()` / `requestPermission()`) before subscribing; bail out silently if denied — don't crash or block the UI.
   - Use `Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: high, distanceFilter: ~10m))`, and on each update just `setState` the new position.
   - Cancel the subscription in `dispose()`.

4. **Wiring**: In the bloc/state listener where the trip phase transitions to in-progress, trigger `_startLiveLocationTracking()`. Pass `_calculateTripProgress(summary, eta)` into the card widget wherever it's built.

Keep the widget itself dumb (just renders whatever `progress` it's given); all the phase/GPS/ETA branching lives in the screen's state class.

---

Swap in the relevant field names (trip phase enum, origin/destination lat-lng fields, ETA source) for whichever screen you're applying this to.
