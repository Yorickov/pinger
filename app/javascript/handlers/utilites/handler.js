export default (event) => {
  const { target, detail } = event;
  if (!target.classList.contains('ping-link')) {
    return;
  }

  event.preventDefault();

  const { status } = detail[0];
  const pingBoxNode = document.querySelector('.ping-wrapper .ping-box');
  if (pingBoxNode.children.length > 0) {
    pingBoxNode.innerHTML = '';
  }

  const pingInfoNode = document.createElement('div');
  pingInfoNode.classList.add('mb-3', 'card-text')

  const optContent = status === 'errored' ? '' : ` Response: ${detail[0].response_time}`;
  const content = `Status: ${status}${optContent}`;
  pingInfoNode.innerHTML = content;

  pingBoxNode.append(pingInfoNode);
};
