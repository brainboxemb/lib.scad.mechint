//////////////////////////////////////////////////////////////////////
// LibFile: sliding_dovetail_lock.scad
//   Optional locking configuration for a sliding-dovetail interface.
//////////////////////////////////////////////////////////////////////

// Function: sliding_dovetail_lock_create()
// Synopsis: Creates optional locking configuration for a sliding dovetail.
// Arguments:
//   enabled = Whether locking geometry is enabled.
function sliding_dovetail_lock_create(
    enabled = false
) =
    assert(
        is_bool(enabled),
        "sliding dovetail lock enabled must be boolean"
    )
    object(
        enabled = enabled
    );

// Function: sliding_dovetail_lock_enabled()
// Synopsis: Returns whether the lock configuration is enabled.
function sliding_dovetail_lock_enabled(lock) =
    lock.enabled;
