function postData() {
    const target = this.classList[0];
    const tr = this.parentNode.parentNode;
    const data = new FormData();
    data.append("when", tr.querySelector(".when").value);
    if (target == "log") {
        data.append("bank", tr.querySelector(".bank").value);
        data.append("cash", tr.querySelector(".cash").value);
        data.append("prepaid", tr.querySelector(".prepaid").value);
        data.append("card", tr.querySelector(".card").value);
        data.append("adj", tr.querySelector(".adj").value);
    } else if (target == "exp") {
        data.append("title", tr.querySelector(".title").value);
        data.append("exp", tr.querySelector(".exp").value);
        data.append("month", tr.querySelector(".month").value);
    }
    fetch(appName + "/update/" + target, {
        method: "POST",
        body: data,
    }).then(response => {
        if (!response.ok) {
            throw new Error("response error");
        }
        return response.json();
    }).then(data => {
        if (data.err) {
            throw new Error(data.err);
        } else {
            alert("更新しました");
            location.reload();
        }
    }).catch(err => {
        alert(err);
    });
}

function setLogData(data) {
    const tbody = select("table.log tbody");
    for (const log of data) {
        const tr = document.createElement("tr");

        let td = document.createElement("td");
        let ipt = document.createElement("input");
        ipt.type = "date";
        ipt.classList.add("when");
        ipt.value = log.when;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        td = document.createElement("td");
        ipt = document.createElement("input");
        ipt.type = "number";
        ipt.classList.add("price");
        ipt.classList.add("bank");
        ipt.value = log.bank;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        td = document.createElement("td");
        ipt = document.createElement("input");
        ipt.type = "number";
        ipt.classList.add("price");
        ipt.classList.add("cash");
        ipt.value = log.cash;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        td = document.createElement("td");
        ipt = document.createElement("input");
        ipt.type = "number";
        ipt.classList.add("price");
        ipt.classList.add("prepaid");
        ipt.value = log.auPay;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        td = document.createElement("td");
        ipt = document.createElement("input");
        ipt.type = "number";
        ipt.classList.add("price");
        ipt.classList.add("card");
        ipt.value = log.card;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        td = document.createElement("td");
        ipt = document.createElement("input");
        ipt.type = "number";
        ipt.classList.add("price");
        ipt.classList.add("adj");
        ipt.value = log.adj;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        tbody.appendChild(tr);
    }

    const tr = tbody.lastChild.cloneNode(true);
    for (const ipt of tr.querySelectorAll("input")) {
        ipt.disabled = false;
        ipt.value = "";
    }
    tr.querySelector("input[type='date']").value = getDateString(new Date());
    const td = document.createElement("td");
    const btn = document.createElement("button");
    btn.type = "button";
    btn.classList.add("log");
    btn.textContent = "追加";
    btn.addEventListener('click', postData);
    td.appendChild(btn);
    tr.appendChild(td);
    tbody.appendChild(tr);
}

function setExpData(data) {
    const tbody = select("table.exp tbody");
    for (const exp of data) {
        const tr = document.createElement("tr");

        let td = document.createElement("td");
        let ipt = document.createElement("input");
        ipt.type = "date";
        ipt.classList.add("when");
        ipt.value = exp.when;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        td = document.createElement("td");
        ipt = document.createElement("input");
        ipt.classList.add("title");
        ipt.value = exp.title;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        td = document.createElement("td");
        ipt = document.createElement("input");
        ipt.type = "number";
        ipt.classList.add("price");
        ipt.classList.add("exp");
        ipt.value = exp.exp;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        td = document.createElement("td");
        ipt = document.createElement("input");
        ipt.type = "number";
        ipt.classList.add("month");
        ipt.value = exp.month;
        ipt.disabled = true;
        td.appendChild(ipt);
        tr.appendChild(td);

        tbody.appendChild(tr);
    }

    const tr = tbody.lastChild.cloneNode(true);
    for (const ipt of tr.querySelectorAll("input")) {
        ipt.disabled = false;
        ipt.value = "";
    }
    tr.querySelector("input[type='date']").value = getDateString(new Date());
    const td = document.createElement("td");
    const btn = document.createElement("button");
    btn.type = "button";
    btn.classList.add("exp");
    btn.textContent = "追加";
    btn.addEventListener('click', postData);
    td.appendChild(btn);
    tr.appendChild(td);
    tbody.appendChild(tr);
}

self.window.addEventListener('load', function() {
    fetch(appName + "/logdata", {
        method: "GET",
    }).then(response => {
        if (!response.ok) {
            throw new Error("response error");
        }
        return response.json();
    }).then(data => {
        setLogData(data.log);
        setExpData(data.exp);
    }).catch(err => {
        alert(err);
    });
});
