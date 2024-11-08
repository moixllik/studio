module Main where

import Test.Tasty
import Test.Tasty.HUnit

import Lib

main:: IO()
main = defaultMain tests

degrees = 45
angle = 1 / 4 * pi
hypotenuse = 1.0
leg = sqrt 2 / 2
x = leg
y = leg

tests :: TestTree
tests = testGroup "Tests"
    [ testCase "sinusoidalWave" $
        -2.0 @?=
            sinusoidalWave
                2.0     -- A
                4.0     -- lambda
                0.5     -- tau
                0.0     -- delta
                3.0     -- x
                1.0     -- t

    , testCase "toDecimal 5" $
        0.78539 @?= toDecimal 5 angle

    , testCase "toRadians degrees" $
        angle @?= toRadians degrees

    , testCase "toDegrees radians" $
        degrees @?= toDegrees angle

    , testCase "hypotenuseXY" $
        hypotenuse @?= hypotenuseXY x y

    , testCase "sinXY" $
        sin angle @?= sinXY x y

    , testCase "cosXY" $
        cos angle @?= cosXY x y

    , testCase "tanXY" $
        tan angle @?= tanXY x y

    , testCase "cotXY" $
        (1 / tan angle) @?= cotXY x y

    , testCase "cscXY" $
        (1 / sin angle) @?= cscXY x y

    , testCase "secXY" $
        (1 / cos angle) @?= secXY x y

    , testCase "asinXY" $
        asin (sin angle) @?= asinXY x y

    , testCase "acosXY" $
        acos (cos angle) @?= acosXY x y
     ]
