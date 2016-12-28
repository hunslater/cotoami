module App.Model exposing (..)

import App.Types
import Components.SigninModal
import Components.Timeline


type alias Model =
    { ctrlDown : Bool
    , session : Maybe App.Types.Session
    , signinModal : Components.SigninModal.Model
    , timeline : Components.Timeline.Model
    }


initModel : Model
initModel =
    { ctrlDown = False
    , session = Nothing
    , signinModal = Components.SigninModal.initModel
    , timeline = Components.Timeline.initModel
    }
