//Cria menu na planilha
function onOpen() {

    var menu = [{ name: 'Montar Formulário do Quiz', functionName: 'setUpForm' }];
    SpreadsheetApp.getActive().addMenu('Quiz', menu);

}

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
    var sheet = SpreadsheetApp.getActiveSheet();
    var range = sheet.getDataRange();
    var values = range.getValues();

    //Criação do Form
    var form = FormApp.create('Simulador Salesforce Marketing Cloud Certification');

    //Muda o tipo de formulário para quiz
    form.setIsQuiz(true);

    for (var i = 1; i < values.length; i++) {

        if (values[i][1] == "CHECKBOX") {

            var item = form.addCheckboxItem().setTitle(values[i][2]);
            choice_values = []

            // Pergunta obrigatória
            item.setRequired(true)

            // Pontuação da Pergunta
            item.setPoints(1)

            // Vetor auxiliar de respostas corretas
            rp = resp_certa(values[i][8].split(','));
            k = 0;


            for (var j = 3; j < 8; j++) {
                if (values[i][j] != '' && rp[k] == 1) {

                    choice_values.push(item.createChoice(values[i][j], true))
                    k++;
                }
                else if (values[i][j] != '' && rp[k] == 0) {
                    choice_values.push(item.createChoice(values[i][j], false))
                    k++;
                }

            }

            item.setChoices(choice_values)
        }

        else {

            var item = form.addMultipleChoiceItem().setTitle(values[i][2]);

            // Pergunta obrigatória
            item.setRequired(true)

            // Pontuação da Pergunta
            item.setPoints(1)

            // Vetor auxiliar de respostas corretas
            rp = resp_certa(values[i][8].split(','));
            k = 0;

            choice_values = []

            for (var j = 3; j < 8; j++) {

                if (values[i][j] != '' && rp[k] == 1) {

                    choice_values.push(item.createChoice(values[i][j], true))
                    k++;
                }
                else if (values[i][j] != '' && rp[k] == 0) {
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