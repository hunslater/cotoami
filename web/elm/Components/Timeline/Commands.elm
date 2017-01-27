module Components.Timeline.Commands exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Dom
import Dom.Scroll
import Task
import Process
import Time
import Http
import Components.Timeline.Model exposing (Coto)
import Components.Timeline.Messages exposing (..)


scrollToBottom : Cmd Msg
scrollToBottom =
    Process.sleep (1 * Time.millisecond)
    |> Task.andThen (\x -> (Dom.Scroll.toBottom "timeline"))
    |> Task.attempt handleScrollResult 


handleScrollResult : Result Dom.Error () -> Msg
handleScrollResult result =
    case result of
        Ok _ ->
            NoOp

        Err _ ->
            NoOp


fetchCotos : Cmd Msg
fetchCotos =
    Http.send CotosFetched (Http.get "/api/cotos" (Decode.list decodeCoto))


postCoto : Coto -> Cmd Msg
postCoto coto =
    Http.send 
        CotoPosted 
        (Http.post "/api/cotos" (Http.jsonBody (encodeCoto coto)) decodeCoto)
        
        
decodeCoto : Decode.Decoder Coto
decodeCoto =
    Decode.map4 Coto
        (Decode.maybe (Decode.field "id" Decode.int))
        (Decode.maybe (Decode.field "postId" Decode.int))
        (Decode.field "content" Decode.string)
        (Decode.succeed False)


encodeCoto : Coto -> Encode.Value
encodeCoto coto =
    Encode.object 
        [ ("coto", 
            (Encode.object 
                [ ("postId", 
                    case coto.postId of
                        Nothing -> Encode.null 
                        Just postId -> Encode.int postId
                  )
                , ("content", Encode.string coto.content)
                ]
            )
          )
        ]