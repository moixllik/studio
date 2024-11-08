module Lib where

sinusoidalWave :: Float -> Float -> Float -> Float -> Float -> Float -> Float
sinusoidalWave
    amplitude   -- A: units
    wave_length -- lambda: metric
    frequency   -- tau: hz
    phase_shift -- delta: rad
    position_space  -- x: metric
    time            -- t: time
    = amplitude * sin
        ( wave_number * position_space
        - angular_frequency * time
        + phase_shift
        )
    where
        angular_frequency = 2 * pi / frequency -- omega
        wave_number = 2 * pi / wave_length -- kappa

toRadians :: Float -> Float
toRadians degrees = degrees * pi / 180

toDegrees :: Float -> Float
toDegrees radians = radians * 180 / pi

toDecimal :: Float -> Float -> Float
toDecimal places number = fromIntegral (truncate (number * n)) / n
    where n = 10 ** places

hypotenuseXY :: Float -> Float -> Float
hypotenuseXY
    x -- adjacent
    y -- opposite
    = sqrt(x^2 + y^2)

sinXY :: Float -> Float -> Float
sinXY x y = y / (hypotenuseXY x y)

cosXY :: Float -> Float -> Float
cosXY x y = x / (hypotenuseXY x y)

tanXY :: Float -> Float -> Float
tanXY x y = y / x -- sin / cos

cotXY :: Float -> Float -> Float
cotXY x y = x / y -- 1 / tan

cscXY :: Float -> Float -> Float
cscXY x y = (hypotenuseXY x y) / y -- 1 / sin

secXY :: Float -> Float -> Float
secXY x y = (hypotenuseXY x y) / x -- 1 / cos

asinXY :: Float -> Float -> Float
asinXY x y = aprox -- radians
    where
        s = sinXY x y
        aprox = s + (s^3 / 6) + (3 * s^5 / 40) + (5 * s^7 / 112)

acosXY :: Float -> Float -> Float
acosXY x y = (pi / 2) - (asinXY x y)
