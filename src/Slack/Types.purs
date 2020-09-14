module Slack.Types where

import Prelude

import Payload.ContentType (class HasContentType, json)

import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe)
import Foreign.Generic (genericEncodeJSON)
import Foreign.Generic.Class (defaultOptions)
import Payload.Client.EncodeBody (class EncodeBody)


newtype CreateChannel = CreateChannel
  { is_private :: Boolean
  , name :: String
  , description :: Maybe String
  , org_wide :: Maybe Boolean
  , team_id :: Maybe String
  }

derive instance genc :: Generic CreateChannel _

instance hc :: HasContentType CreateChannel where
  getContentType _ = json

instance ec :: EncodeBody CreateChannel where
  encodeBody = genericEncodeJSON (defaultOptions { unwrapSingleConstructors = true})

newtype CreateChannelResponse = CreateChannelResponse
  { ok :: String
  , channel_id :: String
  }

instance sc :: Show CreateChannelResponse where
  show (CreateChannelResponse c) = c.ok <> " - " <> c.channel_id
