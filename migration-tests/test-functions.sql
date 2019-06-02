-- Start a transaction.
BEGIN;

-- Plan the tests.
SELECT tap.plan(2);

SELECT tap.eq(fnc_HoursToSeconds(1), 3600, '1 Hour equals 3600 Seconds');
SELECT tap.eq(fnc_SESSION_LENGTH(), 14400, 'Session Length equals 14400 Seconds');

-- Finish the tests and clean up.
CALL tap.finish();
ROLLBACK;