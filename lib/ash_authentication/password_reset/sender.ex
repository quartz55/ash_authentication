defmodule AshAuthentication.PasswordReset.Sender do
  @moduledoc ~S"""
  A module to implement sending of the password reset token to a user.

  Allows you to glue sending of reset instructions to
  [swoosh](https://hex.pm/packages/swoosh),
  [ex_twilio](https://hex.pm/packages/ex_twilio) or whatever notification system
  is appropriate for your application.

  Note that the return value and any failures are ignored.  If you need retry
  logic, etc, then you should implement it in your sending system.

  ## Example

  Implementing as a module:

  ```elixir
  defmodule MyApp.PasswordResetSender do
    use AshAuthentication.PasswordReset.Sender
    import Swoosh.Email
    alias MyAppWeb.Router.Helpers, as: Routes

    def send(user, reset_token, _opts) do
      new()
      |> to({user.name, user.email})
      |> from({"Doc Brown", "emmet@brown.inc"})
      |> subject("Password reset instructions")
      |> html_body("
        <h1>Password reset instructions</h1>
        <p>
          Hi #{user.name},<br />

          Someone (maybe you) has requested a password reset for your account.
          If you did not initiate this request then please ignore this email.
        </p>
        <a href="#{Routes.auth_url(MyAppWeb.Endpoint, :reset_password, token: reset_token)}">
          Click here to reset
        </a>
      ")
      |> MyApp.Mailer.deliver()
    end
  end

  defmodule MyApp.Accounts.User do
    use Ash.Resource, extensions: [AshAuthentication, AshAuthentication.PasswordAuthentication, AshAuthentication.PasswordRest]

    password_reset do
      sender MyApp.PasswordResetSender
    end
  end
  ```

  You can also implment it directly as a function:


  ```elixir
  defmodule MyApp.Accounts.User do
    use Ash.Resource, extensions: [AshAuthentication, AshAuthentication.PasswordAuthentication, AshAuthentication.PasswordRest]

    password_reset do
      sender fn user, token, _opt ->
        MyApp.Mailer.send_password_reset_email(user, token)
      end
    end
  end
  ```
  """

  alias Ash.Resource

  @callback send(user :: Resource.record(), reset_token :: String.t(), opts :: list) :: :ok

  @doc false
  @spec __using__(any) :: Macro.t()
  defmacro __using__(_) do
    quote do
      @behaviour AshAuthentication.PasswordReset.Sender
    end
  end
end