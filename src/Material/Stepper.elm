module Material.Stepper exposing
    (
     Model, Step, Config
    , stepper, horizontal, linear, conf, init
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events
import Html.App
import Platform.Cmd exposing (Cmd, none)

import Material.Options as Options exposing (Style, cs, css, when)

-- MODEL

type alias Config =
    { title : String
    , subtitle : Maybe String
    , index : Int
    , error : Maybe String
    , complete : Bool
    }

type alias Model =
    { active : Int
    , steps : List Config
    }

-- TODO: Initialize w/ active step
init : List Config -> Model
init steps =
    Model 0 steps


-- ACTION/UPDATE

type Msg
    = NoOp


-- VIEW

horizontal : Style a
horizontal =
    Options.cs "mdl-stepper--horizontal"


linear : Style a
linear =
    Options.cs "mdl-stepper--linear"

conf : Int -> String -> Maybe String -> Config
conf index title subtitle =
    Config title subtitle index Nothing False

-- step : Config -> Html a -> Step a
-- step conf content =
--     ( conf, content )

-- steps : Model -> List (Step a)

type alias Step a =
    ( Config, Html a )


stepper : Model -> List (Style a) -> List (Step a) -> Html a
stepper model styling steps =
    Options.styled Html.ul
        (List.append styling [ cs "mdl-stepper" ])
        (List.map (renderStep model.active) steps)

renderStep : Int -> Step a -> Html a
renderStep activeIdx (config, content) =
    Options.styled Html.li
        [ cs "mdl-step"
        , cs "is-active" `when` (activeIdx == config.index)
        ]
        [ renderStepTitle config
        , Options.div
            [ cs "mdl-step__content"]
            [ content ]
        ]

renderStepTitle : Config -> Html a
renderStepTitle {title,subtitle,index,error,complete} =
    Options.span
        [ cs "mdl-step__label "]
        [ Options.span
              [ cs "mdl-step__title" ]
              [ Options.span
                    [ cs "mdl-step__title-text" ]
                    [ text title ]
              ]
        , Options.span
            [ cs "mdl-step__label-indicator" ]
            [ Options.span
                  [ cs "mdl-step__label-indicator-content" ]
                  [ index + 1 |> toString |> text ]
            ]
        ]
