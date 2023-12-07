package com.fabio.backend.firebase;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.io.InputStream;

@Service
public class FirebaseInitialization {

    @PostConstruct
    public void initialization() {
        try {
            // Tente obter o arquivo de chave de serviço
            InputStream serviceAccount = getClass().getClassLoader().getResourceAsStream("serviceAccountKey.json");

            if (serviceAccount == null) {
                throw new IOException("Arquivo serviceAccountKey.json não encontrado.");
            }

            // Configure as opções do Firebase
            FirebaseOptions options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            // Inicialize o FirebaseApp
            FirebaseApp.initializeApp(options);

            // Se chegar aqui, a inicialização foi bem-sucedida
            System.out.println("Conexão com o banco de dados Firebase bem-sucedida.");

        } catch (IOException e) {
            // Se ocorrer uma exceção de E/S, imprima a mensagem de erro
            System.err.println("Erro durante a inicialização do Firebase:");
            e.printStackTrace();
        }
    }
}
