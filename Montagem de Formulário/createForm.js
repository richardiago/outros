//Constantes
const TIPO = 1;                 //coluna que armazena o tipo de questão
const PERGUNTAS = 2;            //coluna em que ficam as Perguntas
const START_ALTERNATIVAS = 3    //coluna em que se iniciam as alternativas
const END_ALTERNATIVAS = 7      //coluna em que se encerram as alternativas
const RESP_CERTAS = 8;          //coluna que armazena as respostas
const PERG_POR_SECAO = 60;      //número de perguntas por seção do formulário

//Cria menu na planilha
function onOpen() {

    var menu = [{ name: 'Montar Formulário do Quiz', functionName: 'setUpForm' }];
    SpreadsheetApp.getActive().addMenu('Quiz', menu);

}

// Função auxiliar para identificar as alternativas corretas
function resp_certa(respostas) {
    rp = [0, 0, 0, 0, 0]

    for (var i = 0; i < respostas.length; i++) {

        switch (respostas[i]) {
            case 'A':
                rp[0] = 1;
                break;

            case 'B':
                rp[1] = 1;
                break;

            case 'C':
                rp[2] = 1;
                break;

            case 'D':
                rp[3] = 1;
                break;

            case 'E':
                rp[4] = 1;
                break;
        }
    }

    return rp;

}

//Cria formulário
function setUpForm() {

    // Dados da planilha
    var sheet = SpreadsheetApp.getActiveSheet();  //Seleciona a planilha que está ativa
    var range = sheet.getDataRange();             //Seleciona o intervalo da planilha que contêm dados
    var values = range.getValues();               //Monta uma matriz com o conteúdo da planilha

    //Criação do Form com perguntas embaralhadas
    var form = FormApp.create('Simulador Salesforce Marketing Cloud Certification').setShuffleQuestions(true);

    //Muda o tipo de formulário para quiz
    form.setIsQuiz(true);

    //Coleta de email
    form.setCollectEmail(true);

    //Exige Login para responder quiz - só funciona se rodar o script com conta G Suite
    //caso contrário comente a próxima linha
    form.setRequireLogin(true);

    //Exibe barra de progresso
    form.setProgressBar(true);

    //Variavel auxiliar para a criação de seções
    var section = 0;

    // Cria cada pergunta
    for (var i = 1; i < values.length; i++) {

        //A cada 60 questões cria uma nova seção no quiz
        if(section == PERG_POR_SECAO){
            form.addPageBreakItem().setTitle('');
            section = 1;
        }
        else section +=1;

        //Pergunta do tipo "Checkbox"
        if (values[i][TIPO] == "CHECKBOX") {

            //Adiciona pergunta do tipo que só tem uma reposta certa
            var item = form.addCheckboxItem().setTitle(values[i][PERGUNTAS]);
            choice_values = []

            // Pergunta obrigatória
            //item.setRequired(true)

            // Pontuação da Pergunta
            item.setPoints(1)

            // Vetor auxiliar de respostas corretas
            rp = resp_certa(values[i][RESP_CERTAS].split(','));
            k = 0;


            for (var j = START_ALTERNATIVAS; j <= END_ALTERNATIVAS; j++) {
                if (values[i][j] != '' && rp[k] == 1) {

                    //Alternativa correta
                    choice_values.push(item.createChoice(values[i][j], true))
                    k++;
                }
                else if (values[i][j] != '' && rp[k] == 0) {
                    
                    //Alternativa incorreta
                    choice_values.push(item.createChoice(values[i][j], false))
                    k++;
                }

            }

            item.setChoices(choice_values)
        }

        //Pergunta do tipo "Choice"
        else {

            //Adiciona pergunta do tipo que tem mais de uma reposta certa
            var item = form.addMultipleChoiceItem().setTitle(values[i][PERGUNTAS]);

            // Pergunta obrigatória
            //item.setRequired(true)

            // Pontuação da Pergunta
            item.setPoints(1)

            // Vetor auxiliar de respostas corretas
            rp = resp_certa(values[i][RESP_CERTAS].split(','));
            k = 0;

            choice_values = []

            for (var j = START_ALTERNATIVAS; j <= END_ALTERNATIVAS; j++) {

                if (values[i][j] != '' && rp[k] == 1) {

                    //Alternativa correta
                    choice_values.push(item.createChoice(values[i][j], true))
                    k++;
                }
                else if (values[i][j] != '' && rp[k] == 0) {
                    //Alternativa incorreta
                    choice_values.push(item.createChoice(values[i][j], false))
                    k++;
                }

            }
            item.setChoices(choice_values);

            //Não mostrar "Outra opção"
            item.showOtherOption(false);

        }

    }
}
