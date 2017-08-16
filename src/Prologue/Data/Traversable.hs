module Prologue.Data.Traversable (module Prologue.Data.Traversable, module X) where

import Prelude
import           Data.Kind       (Constraint)
import qualified Data.Traversable as T
import           Data.Traversable as X (Traversable, traverse, mapM, for)


type family Traversables (lst :: [* -> *]) :: Constraint where
    Traversables '[]       = ()
    Traversables (t ': ts) = (Traversable t, Traversables ts)

sequence :: (Traversable t, Applicative f) => t (f a) -> f (t a)
sequence = T.sequenceA ; {-# INLINE sequence #-}

infixl 4 <$>=
infixl 4 <<$>>=
infixl 4 <<<$>>>=
infixl 4 <<<<$>>>>=
infixl 4 <<<<<$>>>>>=
(<$>=)                 :: (Monad m, Traversable  t1)                    => (a -> m b) ->                 t1 a     -> m                 (t1 b)
(<<$>>=)       , mapM2 :: (Monad m, Traversables '[t1, t2])             => (a -> m b) ->             t2 (t1 a)    -> m             (t2 (t1 b))
(<<<$>>>=)     , mapM3 :: (Monad m, Traversables '[t1, t2, t3])         => (a -> m b) ->         t3 (t2 (t1 a))   -> m         (t3 (t2 (t1 b)))
(<<<<$>>>>=)   , mapM4 :: (Monad m, Traversables '[t1, t2, t3, t4])     => (a -> m b) ->     t4 (t3 (t2 (t1 a)))  -> m     (t4 (t3 (t2 (t1 b))))
(<<<<<$>>>>>=) , mapM5 :: (Monad m, Traversables '[t1, t2, t3, t4, t5]) => (a -> m b) -> t5 (t4 (t3 (t2 (t1 a)))) -> m (t5 (t4 (t3 (t2 (t1 b)))))
mapM2          = mapM . mapM  ; {-# INLINE mapM2          #-}
mapM3          = mapM . mapM2 ; {-# INLINE mapM3          #-}
mapM4          = mapM . mapM3 ; {-# INLINE mapM4          #-}
mapM5          = mapM . mapM4 ; {-# INLINE mapM5          #-}
(<$>=)         = mapM         ; {-# INLINE (<$>=)         #-}
(<<$>>=)       = mapM2        ; {-# INLINE (<<$>>=)       #-}
(<<<$>>>=)     = mapM3        ; {-# INLINE (<<<$>>>=)     #-}
(<<<<$>>>>=)   = mapM4        ; {-# INLINE (<<<<$>>>>=)   #-}
(<<<<<$>>>>>=) = mapM5        ; {-# INLINE (<<<<<$>>>>>=) #-}


-- === Argument capturing traversals === --

infixl 4 <|$>=
infixl 4 <$|>=
(<|$>=) :: (Traversable t, Monad m) => (a -> m b) -> t a -> m (t (a, b))
(<$|>=) :: (Traversable t, Monad m) => (a -> m b) -> t a -> m (t (b, a))
f <|$>= ta = (\a -> (a,) <$> f a) <$>= ta ; {-# INLINE (<|$>=) #-}
f <$|>= ta = (\a -> (,a) <$> f a) <$>= ta ; {-# INLINE (<$|>=) #-}