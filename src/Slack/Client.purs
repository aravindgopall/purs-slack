module Slack.Client where

import Prelude
import Data.Maybe (Maybe(..), maybe)
import Data.Tuple (Tuple(..))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Payload.Client (defaultOpts, mkGuardedClient, unwrapBody)
import Payload.Client.Options (LogLevel(..))
import Payload.Debug (showDebug)
import Payload.Headers as Headers
import Payload.Spec (Spec(..), POST)
import Slack.Types (ChannelRequest(..), CreateChannel(..), CreateChannelResponse, OkResponse(..), UserRequest(..))

type S
  = { routes ::
        { createChannel :: POST "/admin.conversations.create" { body :: CreateChannel, response :: CreateChannelResponse }
        , archiveChannel :: POST "/admin.conversations.archive" { body :: ChannelRequest, response :: OkResponse }
        , deleteChannel :: POST "/admin.conversations.delete" { body :: ChannelRequest, response :: OkResponse }
        , inviteUser :: POST "/admin.conversations.invite" { body :: UserRequest, response :: OkResponse }
        }
    }

spec :: Spec S
spec = Spec

createClient =
  let
    authTokenHeaders = maybe [] (\token -> [ Tuple "Authorization" ("token " <> token) ]) (Just "")

    extraHeaders = Headers.fromFoldable ([ Tuple "Accept" "application/json" ] <> authTokenHeaders)

    opts =
      defaultOpts
        { baseUrl = "https://slack.com/api"
        , logLevel = LogNormal
        , extraHeaders = extraHeaders
        }
  in
    mkGuardedClient opts spec

{--callCreateChannel :: forall client. ClientApi S client ⇒ client -> Effect Unit--}
callCreateChannel client = do
  let
    cc = CreateChannel { is_private: true, name: "aravind-ch1", description: Nothing, org_wide: Just true, team_id: Nothing }
  launchAff_
    $ do
        repos <- unwrapBody (client.createChannel { body: cc })
        liftEffect $ log $ "Repos:\n" <> showDebug repos

callArchiveChannel client = do
  let
    ac = ChannelRequest { channel_id: "aravind-ch1" }
  launchAff_
    $ do
        repos <- unwrapBody (client.archiveChannel { body: ac })
        liftEffect $ log $ "Repos:\n" <> showDebug repos

callDeleteChannel client = do
  let
    ac = ChannelRequest { channel_id: "aravind-ch1" }
  launchAff_
    $ do
        repos <- unwrapBody (client.deleteChannel { body: ac })
        liftEffect $ log $ "Repos:\n" <> showDebug repos

callInviteUsers client = do
  let
    ac = UserRequest { channel_id: "aravind-ch1", user_ids: [ "aravindgopall" ] }
  launchAff_
    $ do
        repos <- unwrapBody (client.inviteUser { body: ac })
        liftEffect $ log $ "Repos:\n" <> showDebug repos
