document.querySelector('button').addEventListener('click', calculate);

function calculate(event){
	event.preventDefault();
	let montly = parseFloat(document.getElementById('montly').value);
	let months = parseInt(document.getElementById('months').value);
	let tds = document.querySelectorAll('td');
	let all = 0;
	for (let td=0; td < months; td++){
		let num = Math.round(parseFloat(tds[td].textContent) * 100) / 100;
		montly = Math.round(montly * 100) / 100;
		all += montly / num;
	}
	let p = document.createElement('p');
	let last = tds[tds.length-1];
	all *= parseFloat(last.textContent);
	all = Math.round(all * 100) / 100;
	p.textContent = all;
	document.querySelector('body').prepend(p);	
}
