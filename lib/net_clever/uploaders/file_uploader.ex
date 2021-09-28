defmodule NetClever.Uploaders.FileUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:final]

  @valid_formats ~w(.doc .docx .pages .rtf .tex .txt .csv .dat .key .keychain
  .pps .ppt .pptx .mp3 .mpa .wav .wma .m4a .avi .flv .m4v
  .mov .mp4 .mpg .wmv .3dm .3ds .max .bmp .dds .gif .heic
  .jpg .jpeg .png .psd .pspimage .tga .thm .yuv .ai .eps
  .svg .indd .pct .pdf .xlr .xls .xlsx .dwg .df .dgn .stl
  .JPG)

  def validate({file, _}) do
    @valid_formats |> Enum.member?(Path.extname(file.file_name))
  end

  def storage_dir(_, {_file, schema}) do
    "uploads/#{schema.__meta__.source}/#{schema.external_id}"
    # if System.get_env("APP_ENV") != "production" do
    #   if Mix.env() == :test do
    #     "uploads/test/#{schema.__meta__.source}/#{schema.external_id}"
    #   else
    #     "uploads/#{schema.__meta__.source}/#{schema.external_id}"
    #   end
    # else
    #   "uploads/#{schema.__meta__.source}/#{schema.external_id}"
    # end
  end
end
