defmodule AhorcadoTest do
  use ExUnit.Case
  doctest Ahorcado

  test "greets the world" do
    assert Ahorcado.hello() == :world
  end
end
