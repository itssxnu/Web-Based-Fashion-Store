document.addEventListener('DOMContentLoaded', () => {
    
    const COMPARE_KEY = 'store_compare_ids';

    
    const comparisonTray = document.getElementById('comparison-tray');
    const compareCountEl = document.getElementById('compare-count');
    const compareClearBtn = document.getElementById('compare-clear-btn');
    const compareSubmitBtn = document.getElementById('compare-submit-btn');

    
    const getCompareIds = () => {
        try {
            const raw = localStorage.getItem(COMPARE_KEY);
            return raw ? JSON.parse(raw) : [];
        } catch (e) {
            return [];
        }
    };

    
    const saveCompareIds = (ids) => {
        localStorage.setItem(COMPARE_KEY, JSON.stringify(ids));
        updateTrayVisibility();
        syncCheckboxes();
    };

    
    const updateTrayVisibility = () => {
        if (!comparisonTray) return;
        const ids = getCompareIds();
        
        if (ids.length > 0) {
            compareCountEl.innerText = `${ids.length} item${ids.length > 1 ? 's' : ''} selected for comparison`;
            comparisonTray.style.transform = 'translateY(0)'; 
        } else {
            comparisonTray.style.transform = 'translateY(100%)'; 
        }

        
        if (compareSubmitBtn) {
            compareSubmitBtn.disabled = ids.length < 2;
            if (ids.length < 2) {
                compareSubmitBtn.style.opacity = '0.5';
                compareSubmitBtn.style.cursor = 'not-allowed';
            } else {
                compareSubmitBtn.style.opacity = '1';
                compareSubmitBtn.style.cursor = 'pointer';
            }
        }
    };

    
    const syncCheckboxes = () => {
        const ids = getCompareIds();
        document.querySelectorAll('.compare-checkbox').forEach(cb => {
            const val = parseInt(cb.value, 10);
            cb.checked = ids.includes(val);
        });
    };

    
    document.querySelectorAll('.compare-checkbox').forEach(cb => {
        cb.addEventListener('change', (e) => {
            const val = parseInt(e.target.value, 10);
            let ids = getCompareIds();

            if (e.target.checked) {
                if (ids.length >= 4) {
                    alert('You can only compare a maximum of 4 items at a time.');
                    e.target.checked = false;
                    return;
                }
                if (!ids.includes(val)) ids.push(val);
            } else {
                ids = ids.filter(id => id !== val);
            }
            saveCompareIds(ids);
        });
    });

    
    if (compareClearBtn) {
        compareClearBtn.addEventListener('click', () => {
            saveCompareIds([]);
        });
    }

    
    if (compareSubmitBtn) {
        compareSubmitBtn.addEventListener('click', () => {
            const ids = getCompareIds();
            if (ids.length > 1) {
                window.location.href = `/compare?ids=${ids.join(',')}`;
            }
        });
    }

    
    updateTrayVisibility();
    syncCheckboxes();
});
