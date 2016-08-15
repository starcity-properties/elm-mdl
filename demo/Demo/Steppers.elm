module Demo.Steppers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Material
import Material.Helpers exposing (map1st, map2nd)
import Material.Options as Options exposing (css)
import Material.Stepper as Stepper

import Demo.Code as Code
import Demo.Page as Page

-- MODEL

type alias Model =
    { text : String
    , stepper : Stepper.Model
    , mdl : Material.Model
    , code : Code.Model
    }

model : Model
model =
    { text = "Hello, World!"
    , stepper = Stepper.init
                [ Stepper.conf 0 "Logistics" Nothing
                , Stepper.conf 1 "Personal" Nothing
                ]
    , mdl = Material.model
    , code = Code.model
    }


-- ACTION/UPDATE


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | Code Code.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
    case action of
        Mdl action' ->
            Material.update action' model

        Code action' ->
            Code.update action' model.code
                |> map1st (\code' -> { model | code = code' })
                |> map2nd (Cmd.map Code)

        NoOp ->
            ( model, Cmd.none)



-- VIEW

linear : Model -> (String, Html Msg, String)
linear model =
    let
        steps =
            [ Options.div [] [ text "Content for step 1" ]
            , Options.div [] [ text "Content for step two" ]
            ]
        stepper =
            Stepper.stepper model.stepper
                [ Stepper.horizontal
                , Stepper.linear]
                <| List.map2 (,) model.stepper.steps steps
    in
        ( "Linear stepper", stepper, """TODO:""" )


steppers : Model -> List (Html Msg)
steppers model =
    [ linear model
    ]
    |> List.concatMap
       (\ (title, html, code) ->
            [ Html.h4 [] [ text title ]
            , Options.div
                [ css "display" "flex"
                , css "flex-row" "row wrap"
                , css "align-items" "flex-start"
                ]
                  [ Options.div [ css "margin" "0 24px 24px 0", css "width" "100%" ] [ html ]
                  -- , Code.code [ css "flex-grow" "1", css "margin" "0 0 24px 0" ] code
                  ]
            ]
       )


view : Model -> Html Msg
view model =
    let
        steppers2 =
            [ Html.h4 [] [ text "Nothing to see here. TODO:"]
            ]
    in
    Page.body1' "Steppers" srcUrl intro references
        (steppers model)
        steppers2


intro : Html m
intro =
  Page.fromMDL "FIXME" """
> TODO: I'm a description!
"""


srcUrl : String
srcUrl =
    "FIXME:"


references : List (String, String)
references =
    [ Page.package "FIXME:"
    , Page.mds "https://material.google.com/components/steppers.html"
    , Page.mdl "https://ahlechandre.github.io/mdl-stepper/"
    ]
