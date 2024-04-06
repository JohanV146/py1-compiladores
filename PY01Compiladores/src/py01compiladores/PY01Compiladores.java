/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package py01compiladores;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import static java.time.Clock.system;
import java_cup.parser;
import java_cup.runtime.Symbol;
import jflex.exceptions.SilentExit;
import static jflex.logging.Out.println;

/**
 *
 * @author truez
 */
public class PY01Compiladores {
    /**
     * @param args the command line arguments
     * @throws jflex.exceptions.SilentExit
     * @throws java.lang.Exception
     */
    
    public static void generarLexer(String path) throws SilentExit {
        String[] strArr =  {path};
        jflex.Main.generate(strArr);
    }
    
    public static void generarParser(String path) throws IOException, Exception {
        String[] strArr = { "-parser", "Parser", path };
        java_cup.Main.main(strArr);
    }
    
    public static void test1(String ruta) throws FileNotFoundException, IOException, Exception {
        try (Reader reader = new BufferedReader(new FileReader(ruta))) {
            Lexer lex = new Lexer(reader);
            int i = 0;
            Symbol token;
            while (true) {
                token = lex.next_token();
                if (token.sym != 0) {
                    System.out.println("Token: " + token.sym + " " + (token.value == null ? lex.yytext() : token.value.toString()));
                } else {
                    System.out.println("Cantidad de lexemas encontrados: " + i);
                    return;
                }
                i++;
            }
        }
    }

    
    public static void test2(String ruta) throws IOException, Exception {
        try (Reader reader = new BufferedReader(new FileReader(ruta))) {
            Lexer lex = new Lexer(reader);  // Crea un analizador léxico para el archivo
            Parser myParser = new Parser(lex);  // Crea un analizador sintáctico y le pasa el analizador léxico
            myParser.parse();  // Parsea el contenido del archivo
        }
    }
    
    public static void main(String[] args) throws SilentExit, Exception {
                
        Path currentPath = Paths.get("");
        Path absolutePath = currentPath.toAbsolutePath();
        String currentDirectory = absolutePath.toString(); 
        
        String path = currentDirectory + "\\src\\py01compiladores\\lexer.flex";
        String path2 = currentDirectory + "\\src\\py01compiladores\\ASint.cup";
        
        String path3 = currentDirectory + "\\src\\py01compiladores\\test.txt";
        
        String symLocation = currentDirectory + "\\sym.java";
        String ParserLocation = currentDirectory + "\\Parser.java";
       
        Path sym1 = Paths.get("").toAbsolutePath();
        String symd1 = sym1.toString();
        symd1 = symd1 + "\\src\\py01compiladores\\sym.java";

        Path par1 = Paths.get("").toAbsolutePath();
        String pard1 = par1.toString();
        pard1 = pard1 + "\\src\\py01compiladores\\Parser.java";
        
        generarLexer(path);
        generarParser(path2);
        //
        Files.move(Paths.get(symLocation), Paths.get(symd1), StandardCopyOption.REPLACE_EXISTING);
        Files.move(Paths.get(ParserLocation), Paths.get(pard1), StandardCopyOption.REPLACE_EXISTING);
        
        //test1(path3);
        test2(path3);  
    }
}
