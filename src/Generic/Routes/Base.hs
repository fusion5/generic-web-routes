{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE OverlappingInstances       #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE NoMonomorphismRestriction  #-}

module Generic.Routes.Base (
    showRoute -- route value to string
  , readRoute -- string to route value
) where

import Generic.Routes.Show -- (gRouteShowDefault)
import Generics.Instant.Base

showRoute ::(GRoute' (Rep a), Representable a) => a -> String 
showRoute = gRouteShowDefault 

readRoute ::(GRoute' (Rep a), Representable a) => String -> Maybe a
readRoute = undefined

