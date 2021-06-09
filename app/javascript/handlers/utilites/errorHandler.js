export default (event) => {
  const { target, detail } = event;
  if (!target.classList.contains('ping-link')) {
    return;
  }

  const { message } = detail[0];
  if (message) {
    const pingBoxNode = document.querySelector('.ping-wrapper .ping-box');
    const errorNode = `<div>${message}</div>`
    pingBoxNode.insertAdjacentHTML('afterEnd', errorNode);
  }
};
