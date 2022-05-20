const calculator = document.getElementsByClassName("calculator")[0]

const evaluate = () => {
  try {
    document.calculator.output.value = eval(calculator.output.value).toFixed(4);
    return true;
  } catch {
    alert(`${calculator.output.value} is an invalid input`);
    return false;
  }
}

calculator.addEventListener('click', (event) => {
  if (event.target.classList.contains('arithmetic')) {
    document.calculator.output.value += event.target.value;
  }
})

document.getElementsByClassName("clear")[0].addEventListener('click', (event) => {
  document.calculator.output.value = '';
})

document.getElementsByClassName("plus-minus")[0].addEventListener('click', (event) => {
  if (calculator.output.value[0] != '-') {
    document.calculator.output.value = ('-' + calculator.output.value);
  }
  else {
    document.calculator.output.value = calculator.output.value.slice(1);
  }
})

document.getElementsByClassName("evaluate")[0].addEventListener('click', evaluate)

document.getElementsByClassName("output")[0].addEventListener('keypress', (event) => {
  if (event.key === 'Enter') {
    event.preventDefault();
    return evaluate()
  }
})

document.addEventListener('click', (event) => {
  output = document.getElementsByClassName("output")[0]
  output.focus();
  output.scrollLeft = output.scrollWidth;
})

