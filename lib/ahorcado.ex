defmodule Ahorcado do

  def open_document(name) do
   {_,contents} = File.read(name)
   contents
  end

  def get_words(content) do
    content |> String.split("\r\n", trim: true)
  end

  def validate_char_in_word(word_in_list,letter) do
    unless length(word_in_list)< 1 do
      if word_in_list|>hd()|>to_string() == letter|>to_string() do
        IO.puts("\n***ACERTASTE UNA LETRA***\n")
        letter
      else
        word_in_list|>tl()|>validate_char_in_word(letter)
      end
    end
  end

  def word_control(words) do
    if words |> length() > 0 do
      if hd(words)|>try_word("$",5) == :vencido do
        words|>tl()|>word_control()
      end
    else
      IO.puts("****GANASTE****")
      :FinDelJuego
    end
  end

  def hide_chars(word_to_hide,chars_hidden) do
    if length(word_to_hide|>separate_char()) >1 do
      hc=word_to_hide|>separate_char()|>tl()|>hd
      word_to_hide|>separate_char()|>tl()|>tl()|>to_string()|>hide_chars(chars_hidden<>hc)
    else
      chars_hidden<>word_to_hide
    end
  end

  def replace_word(aList,aString,currentAnswer) do
   newList= aList|>to_string()|>String.replace(currentAnswer|>separate_char(),"")|>separate_char()
   if newList|>length() >0 do
    aString |>String.replace(newList,"?")
   else
    IO.puts("\n\n\n***PALABRA CORRECTA >:)***\n\n\n")
    :ok
   end
  end

  def try_word(current_word,my_word,chance_no) do
    if chance_no>0 do
      hidden_word=current_word|>hide_chars("")|>separate_char()|>replace_word(current_word,my_word)
      if hidden_word != :ok do
        IO.puts("\n\n***Te quedan:  #{chance_no} intento(s)*** \n----Intenta adivinar la siguiente palabra----- \n#{hidden_word}")
        current_char=IO.gets("Escribe un caracter\n")|> String.split("\n", trim: true)
        answer = current_word |> separate_char()|>validate_char_in_word(current_char)
        if answer == nil do
          IO.puts("***FALLASTE D:***\n\n")
          try_word(current_word,my_word,chance_no-1)
        else
          current_answer=answer|>hd()|>to_string()
          try_word(current_word,my_word<>current_answer,chance_no)
          answer
        end
      end
    else
      IO.puts("\n\n\nYa perdiste T_T\n\n\n")
      Process.exit(self(), :normal)
    end
    :vencido
  end

  def separate_char(aString) do
   String.codepoints(aString)
  end

  def start_game() do
   IO.gets("Escribe el nombre del archivo con su terminacion \n")|> String.split("\n", trim: true)|> open_document() |>get_words() |> word_control()
  end

end
