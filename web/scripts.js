let progressBar = document.getElementById('progress-bar');
let progressLabel = document.getElementById('progress-label');
let progressContainer = document.getElementById('progress-container');

function updateProgressBar(duration, label) {
    progressContainer.classList.remove('hidden');
    progressLabel.innerText = label;
    progressBar.style.width = '0%';

    let start = Date.now();
    let interval = setInterval(() => {
        let elapsed = Date.now() - start;
        let percentage = Math.min((elapsed / duration) * 100, 100);
        progressBar.style.width = percentage + '%';

        if (percentage >= 100) {
            clearInterval(interval);
            setTimeout(() => {
                progressContainer.classList.add('hidden');
            }, 500);
        }
    }, 100);
}

window.addEventListener('message', (event) => {
    if (event.data.action === 'progress') {
        updateProgressBar(event.data.data.duration, event.data.data.label);
    } else if (event.data.action === 'progressCancel') {
        progressContainer.classList.add('hidden');
    }
});
