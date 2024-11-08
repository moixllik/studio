module Main where

import Lib
import Graphics.Gloss

main :: IO ()
main = animate window black render
    where window = InWindow "App" (floor width, floor height) (100, 100)

width, height :: Float
width = 800.0
height = 600.0

render time = Pictures [plane, renderWave time]
    where
        w = width / 2.0
        h = height / 2.0
        plane = Pictures
            [ Color white (rectangleSolid width height)
            , line [(0, -h), (0, h)] -- Y
            , line [(-w, 0), (w, 0)] -- X
            ]

renderWave time = Pictures [Color blue wave]
    where
        w = width / 2.0
        am = height / 4 -- amplitude
        wl = width / 4 -- wave length
        fq = 2.0 -- frequency
        ps = 0.0 -- phase shift
        wave = Line $ [(x, sinusoidalWave am wl fq ps x time) | x <- [(-w)..w]]
