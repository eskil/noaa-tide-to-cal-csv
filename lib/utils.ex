defmodule NOAATides.Utils do
  def hackney_level(_debug=true, verbosity) when verbosity>=4, do: 80
  def hackney_level(_debug=true, verbosity) when verbosity>=3, do: 60
  def hackney_level(_debug=true, verbosity) when verbosity>=2, do: 40
  def hackney_level(_debug=true, verbosity) when verbosity>=1, do: 20
  def hackney_level(_debug=true, verbosity) when verbosity>=0, do: 10
  def hackney_level(_debug=false, _), do: 0

  # Utility to set a global
  def set_hackney_logging(debug, verbosity) do
    :hackney_trace.enable(hackney_level(debug, verbosity), :io)
  end
end
