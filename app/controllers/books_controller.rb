class BooksController < ApplicationController
  before_action :set_book , only: [:show, :edit, :update, :destroy]
  before_action :set_books, only: [:index, :download]
  # GET /books
  # GET /books.json
  def index
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    #Crea un excel en la carpeta public
    workbook  = WriteXLSX.new('public/Books.xlsx')
    worksheet = workbook.add_worksheet


    header_format = workbook.add_format(font: "Arial", size: 12, align: "center")
    header_format.set_text_wrap()
    header_format.set_bold
    header_format.set_bg_color("#DFF0D8")
    header_format.set_color("#008857")

    worksheet.set_column('A:A', 45)
    worksheet.set_column('B:B', 45)
    worksheet.set_column('C:C', 45)

    #Encabezados
    #(fila , columna, encabezado)
    worksheet.write(0, 0, ' Titulo ',header_format)
    worksheet.write(0, 1, ' Autor ' ,header_format)
    worksheet.write(0, 2, ' Genero ',header_format)

    #Indices
    fila = 1
    columna = 0

    #Escribe los datos de la bdd
    @books.each do |book|
      worksheet.write(fila, columna       , book.title  )
      worksheet.write(fila, columna + 1   , book.author )
      worksheet.write(fila, columna + 2   , book.genre  )

      #Avanza una fila
      fila += 1
    end

    #Cierra el archivo
    workbook.close()

    #descarga el archivo
    File.open("public/Books.xlsx", "r") do |f|
     send_data f.read, :filename => "Books.xlsx", type: "application/xlsx"
    end

    #Elimina el archivo de la carpet public
    File.delete("public/Books.xlsx")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    def set_books
      @books = Book.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :author, :genre)
    end
end
