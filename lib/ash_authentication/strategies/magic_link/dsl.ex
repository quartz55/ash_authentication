defmodule AshAuthentication.Strategy.MagicLink.Dsl do
  @moduledoc false

  alias AshAuthentication.Strategy.{Custom, MagicLink}
  alias Spark.Dsl.Entity

  @doc false
  @spec dsl :: Custom.entity()
  def dsl do
    %Entity{
      name: :magic_link,
      describe: "Strategy for authenticating using local users with a magic link",
      args: [{:optional, :name, :magic_link}],
      hide: [:name],
      target: MagicLink,
      schema: [
        name: [
          type: :atom,
          doc: "Uniquely identifies the strategy.",
          required: true
        ],
        identity_field: [
          type: :atom,
          doc: """
          The name of the attribute which uniquely identifies the user.

          Usually something like `username` or `email_address`.
          """,
          default: :username
        ],
        token_lifetime: [
          type: :pos_integer,
          doc: """
          How long the sign in token is valid, in minutes.
          """,
          default: 10
        ],
        request_action_name: [
          type: :atom,
          doc: """
          The name to use for the request action.

          If not present it will be generated by prepending the strategy name
          with `request_`.
          """,
          required: false
        ],
        single_use_token?: [
          type: :boolean,
          doc: """
          Automatically revoke the token once it's been used for sign in.
          """,
          default: true
        ],
        sign_in_action_name: [
          type: :atom,
          doc: """
          The name to use for the sign in action.

          If not present it will be generated by prepending the strategy name
          with `sign_in_with_`.
          """,
          required: false
        ],
        token_param_name: [
          type: :atom,
          doc: """
          The name of the token parameter in the incoming sign-in request.
          """,
          default: :token,
          required: false
        ],
        sender: [
          type:
            {:spark_function_behaviour, AshAuthentication.Sender,
             {AshAuthentication.SenderFunction, 3}},
          doc: """
          How to send the magic link to the user.

          Allows you to glue sending of magic links to [swoosh](https://hex.pm/packages/swoosh), [ex_twilio](https://hex.pm/packages/ex_twilio) or whatever notification system is appropriate for your application.

          Accepts a module, module and opts, or a function that takes a record, reset token and options.

          See `AshAuthentication.Sender` for more information.
          """,
          required: true
        ]
      ]
    }
  end
end