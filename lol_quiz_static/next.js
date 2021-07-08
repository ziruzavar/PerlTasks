function script(questionsObjs) {
    let myArrOfRefs = [];
    for (json of questionsObjs){
         myArrOfRefs.push(JSON.parse(json));
    }
    let questionName = document.getElementById('name');
    let current = document.getElementById('current');
    let questions = document.getElementsByTagName('label');
    let button = document.getElementById('next');
    button.addEventListener('click', next);
    let inputs = document.getElementsByTagName('input');
    let curr = 0;
    let right = 0;

    let time = 20;
    let timeEl = document.getElementById('time');
    ///Load first Question
    populateLabels();

    function decrementSeconds(){
        time -= 1;
        timeEl.textContent = `Time left: ${time} seconds`;
        if (time === 0){
            console.log('0 seconds');
            time = 21;
            next();
        }
    }
    setInterval(decrementSeconds, 1000);


    function next() {
        time = 21;
        let givenAnswer = document.querySelector('input:checked');
        if (givenAnswer == null){
            ///Do nothing
        }else {
            if (givenAnswer.value === myArrOfRefs[curr].answer) {
                right += 1;
            }
            givenAnswer.checked = false;
        }

        console.log(right);


        ///load the new Question;
        curr += 1;
        if (curr === 2){
            window.location.replace(`finish.pl/?right=${right}`);
            return
        }
            current.textContent = `(${curr + 1} of 2)`;
            populateLabels();
        if (curr === 1){
            button.classList.add('btn-success');
            button.classList.remove('btn-primary');
            button.textContent = 'Finish'
        }

    }

    function populateLabels() {
        let arr = [ myArrOfRefs[curr].fi_choice,  myArrOfRefs[curr].se_choice, myArrOfRefs[curr].th_choice,  myArrOfRefs[curr].fo_choice];
        ///Labels
        questionName.textContent =  myArrOfRefs[curr].name;
        for (let n=0; n<4; n++){
        questions[n].textContent = arr[n];
        }

        ///Inputs
        for (let n=0; n<4; n++){
        inputs[n].value = arr[n];
        }
    }
}
