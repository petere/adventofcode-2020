coordsFromContent :: String -> [(Integer, Integer, Integer)]
coordsFromContent = coordsFromLines . lines

coordsFromLines :: [String] -> [(Integer, Integer, Integer)]
coordsFromLines lnes = foldr (++) [] $ map (\(n, l) -> coordsFromOneLine n l) $ zip [0..] lnes

coordsFromOneLine :: Integer -> [Char] -> [(Integer, Integer, Integer)]
coordsFromOneLine lineNum line = map (\(n, _) -> (n, lineNum, 0)) $ filter (\(_, c) -> c == '#') $ zip [0..] line

neighbors :: (Integer, Integer, Integer) -> [(Integer, Integer, Integer)]
neighbors (x, y, z) = filter (\(xx, yy, zz) -> (xx, yy, zz) /= (x, y, z))
                      [(x + xx, y + yy, z + zz) | xx <- [-1..1], yy <- [-1..1], zz <- [-1..1]]

intersect :: Eq a => [a] -> [a] -> [a]
intersect [] _ = []
intersect (x:xs) l | elem x l = x : intersect xs l
                   | otherwise = intersect xs l

nextCellState :: (Integer, Integer, Integer) -> [(Integer, Integer, Integer)] -> Bool
nextCellState c grid
  | c `elem` grid = (length activeNeighbors) `elem` [2..3]
  | otherwise = (length activeNeighbors) == 3
  where activeNeighbors = intersect (neighbors c) grid

gridVicinity :: [(Integer, Integer, Integer)] -> [(Integer, Integer, Integer)]
gridVicinity grid = [(x, y, z) | x <- [(minx-1)..(maxx + 1)], y <- [(miny-1)..(maxy+1)], z <- [(minz-1)..(maxz+1)]]
  where minx = minimum $ map (\(x, _, _) -> x) grid
        maxx = maximum $ map (\(x, _, _) -> x) grid
        miny = minimum $ map (\(_, y, _) -> y) grid
        maxy = maximum $ map (\(_, y, _) -> y) grid
        minz = minimum $ map (\(_, _, z) -> z) grid
        maxz = maximum $ map (\(_, _, z) -> z) grid

nextGridState :: [(Integer, Integer, Integer)] -> [(Integer, Integer, Integer)]
nextGridState grid = filter (\c -> nextCellState c grid) (gridVicinity grid)

main :: IO ()
main = do
  content <- readFile "input.txt"
  let grid = coordsFromContent content
  putStrLn $ show $ length $ (iterate nextGridState grid) !! 6
