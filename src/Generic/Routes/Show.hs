{-# LANGUAGE TypeOperators          #-}
{-# LANGUAGE FlexibleContexts       #-}
{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE OverlappingInstances   #-}
{-# LANGUAGE GADTs                  #-}
{-# LANGUAGE UndecidableInstances   #-}
{-# LANGUAGE ScopedTypeVariables    #-}

module Generic.Routes.Show {- (
      gRouteShowDefault
    , gRouteShow
) -} where

import Text.ParserCombinators.Parsec

import Generics.Instant.Base
import Generics.Instant.Instances ()

import Network.URI.Encode

import Control.Applicative hiding ((<|>))

-- type Parser a = GenParser Char 

-- This code was inspired from Generics.Instant.Functions.Show

class GRoute' a where
    gRouteShow' :: a -> String
    gRouteRead' :: Parser a

instance GRoute' U where
    gRouteShow' U = ""
    gRouteRead'   = pzero
  
instance (GRoute' a, GRoute' b) => GRoute' (a :+: b) where
    gRouteShow' (L x) = gRouteShow' x
    gRouteShow' (R x) = gRouteShow' x
    gRouteRead'       = (L <$> gRouteRead') <|> (R <$> gRouteRead')
  
instance (GRoute' a, GRoute' b) => GRoute' (a :*: b) where
    gRouteShow' (a :*: b) = gRouteShow' a `sep` gRouteShow' b
    gRouteRead'           = (:*:) <$> gRouteRead' <* pSep <*> gRouteRead'
instance (GRoute' a, Constructor c) => GRoute' (CEq c p q a) where
    gRouteShow' c@(C a) | gRouteShow' a == "" = conName c
                        | otherwise           = conName c `sep` gRouteShow' a
    gRouteRead' = C <$ pCon cn *> pSep *> gRouteRead'
        where cn = conName (undefined :: C c a)

instance GRoute a => GRoute' (Var a) where
    gRouteShow' (Var x) = gRouteShow x
    gRouteRead' = gRouteRead 

instance GRoute a => GRoute' (Rec a) where
    gRouteShow' (Rec x) = gRouteShow x
    gRouteRead' = gRouteRead

class GRoute a where
    gRouteShow :: a -> String
    gRouteRead :: Parser a

instance GRoute [Char] where 
    gRouteShow = encode

instance GRoute Int where 
    gRouteShow = show 

instance GRoute Integer where 
    gRouteShow = show 

instance (GRoute' (Rep a), Representable a) => GRoute a where
    gRouteShow = gRouteShowDefault
    gRouteRead = gRouteReadDefault

-- Dispatcher
gRouteShowDefault :: (Representable a, GRoute' (Rep a)) => a -> String
gRouteShowDefault = gRouteShow' . from

gRouteReadDefault :: (Representable a, GRoute' (Rep a)) => String -> Maybe a
gRouteReadDefault _ = undefined -- fmap to . gRouteRead'

sep :: String -> String -> String
sep a b = a ++ "/" ++ b

-- Parse constructor name
pCon :: String -> Parser () 
pCon s = do 
    string s
    return ()

pSep :: Parser () 
pSep = do 
    char '/'
    return ()
