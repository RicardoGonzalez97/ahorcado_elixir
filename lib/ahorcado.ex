 defmodule Ahorcado do
 @moduledoc """
  Juego del ahorcado
  """
  def comenzar_juego() do
    IO.gets("Escribe el nombre del archivo con su terminacion \n") |>  String.split("\n", trim: true) |>  abrir_documento() |>  obtener_palabras() |>  control_palabras()
  end


  def control_palabras(palabras) when palabras |> length() > 0 do
    palabras |> hd() |> comenzar_intento("", 5)
    control_palabras(palabras |> tl())
  end
  def control_palabras(_) do
    IO.puts("GANASTE FIN DEL JUEGO :D")
    :fin
  end


  def comenzar_intento(palabra_actual, mi_respuesta, intentos_restantes) when intentos_restantes > 0  do
    palabra_oculta = palabra_actual |> separar_a_char() |> esconder_string("") |> comparar_respuesta(mi_respuesta) |> remplazar_palabras(palabra_actual)
    unless palabra_oculta == :ok do
      case IO.gets("\n\n***Te quedan:  #{intentos_restantes} intento(s)*** \n----Intenta adivinar la siguiente palabra----- \n#{palabra_oculta}\nEscribe un caracter\n") |>  String.split("\n", trim: true)  |> to_string() |> validar_respuesta(palabra_actual) do
        :fail -> comenzar_intento(palabra_actual, mi_respuesta, intentos_restantes - 1)
        letra_correcta -> comenzar_intento(palabra_actual, (mi_respuesta <> letra_correcta), intentos_restantes)
      end
    end
  end

  def comenzar_intento(_, _, intentos_restantes) when intentos_restantes == 0 do
    IO.puts("PERDISTE T.T")
    Process.exit(self(), :normal)
  end


  def remplazar_palabras(letras_a_ocultar, palabra_a_ocultar) when byte_size(letras_a_ocultar) > 0  do
    palabra_a_ocultar  |> String.replace((letras_a_ocultar |> separar_a_char()), "?")
  end
  def remplazar_palabras(_, _)  do
    IO.puts("\n\n\n***PALABRA CORRECTA >:)***\n\n\n")
    :ok
  end


  def validar_respuesta(letra, palabra_actual_) when byte_size(palabra_actual_) > 0  do
    if String.contains?(palabra_actual_, letra) do
      IO.puts("\n***ACERTASTE UNA LETRA***\n")
      letra
    else
      IO.puts("\n***FALLASTE :(***\n")
      :fail
    end
  end


  def comparar_respuesta(letras_ocultas, respuesta_actual) when byte_size(respuesta_actual) > 0 do
   letras_ocultas |> to_string() |> String.replace(respuesta_actual |> separar_a_char(), "")
  end
  def comparar_respuesta(letras_ocultas, _) do
    letras_ocultas
  end


  def esconder_string(lista_a_esconder, char_escondidos) when  lista_a_esconder |> length() > 1 do
    lista_a_esconder |> tl() |> tl()
     |> esconder_string(char_escondidos <> (lista_a_esconder |> tl() |> hd()))
  end
  def esconder_string(_, char_escondidos) do
    char_escondidos
  end


  def obtener_palabras({:ok, contenido})  do
    contenido |> String.split("\r\n", trim: true)
  end
  def obtener_palabras({:error, _}) do
    IO.puts("El documento esta vacio o no existe")
    Process.exit(self(), :normal)
  end


  def separar_a_char(palabra_en_cadena) do
    String.codepoints(palabra_en_cadena)
  end

  def abrir_documento(nombre_archivo) do
    File.read(nombre_archivo)
  end

end
